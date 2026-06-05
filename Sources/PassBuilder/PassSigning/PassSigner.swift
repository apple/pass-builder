//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

private let PKPassFileSuffix = "pkpass"

/// Signs a pass package and produces a distributable `.pkpass` file.
///
/// Use `PassSigner` to cryptographically sign an unsigned pass directory
/// with the appropriate pass and WWDR certificates, and generate a
/// ready-to-distribute Apple Wallet pass.
public struct PassSigner {
    /// The pass certificate, which corresponds to the `passTypeIdentifier` in `pass.json`.
    var passCertificate: PassCertificate

    /// The WWDR intermediate certificate.
    var wwdrCertificate: PassCertificate

    /// Creates a pass signer with the specified configuration.
    ///
    /// - Parameters:
    ///   - passCertificate: The signing certificate matching the pass type identifier.
    ///   - wwdrCertificate: The Apple WWDR intermediate certificate.
    public init(
        passCertificate: PassCertificate,
        wwdrCertificate: PassCertificate
    ) {
        self.passCertificate = passCertificate
        self.wwdrCertificate = wwdrCertificate
    }

    /// Signs the pass and writes the output to disk.
    /// - Parameters:
    ///   - package: The in-memory pass package to build and write to disk.
    ///   - destination: The destination URL for the signed `.pkpass` file, or `nil` to sign in place.
    ///   - options: Options that configure the behavior of the signing process.
    /// - Returns: The URL of the signed pass.
    /// - Throws: ``PassSigningError`` if signing fails, or an error if a file exists at `destination`
    ///   and `options` doesn't contain ``PassSigner/SigningOptions/overwriteExisting``.
    public func signPass(
        _ package: PassPackage,
        destination: URL,
        options: SigningOptions = .default
    ) async throws -> URL {
        let workingURL = determineWritingDestination(passURL: destination, outputURL: destination)

        // Prepare destination.
        try workingURL.prepareForWriting(options: options)
        try workingURL.appendingPathExtension(PKPassFileSuffix).prepareForWriting(options: options)

        // Add to the package.
        let fileWrapper = try package.fileWrapper()

        // Generate the manifest.
        let manifestGenerator = InMemoryManifestGenerator()
        let manifestFile = try await manifestGenerator.generateManifest(for: fileWrapper)

        // Generate the manifest signature.
        let signatureGenerator = ManifestSignatureGenerator(
            passCertificate: passCertificate,
            wwdrCertificate: wwdrCertificate
        )
        let signatureFile = try signatureGenerator.generateSignature(for: manifestFile)

        _ = fileWrapper.addFileWrapper(manifestFile)
        _ = fileWrapper.addFileWrapper(signatureFile)

        // Write the package to disk.
        try fileWrapper.write(to: workingURL, originalContentsURL: nil)

        // Compress the result.
        if options.contains(.zipOutput) {
            let passURL = try await compressBundle(at: workingURL)
            return passURL
        } else {
            return workingURL
        }
    }

    /// Signs the pass and writes the output to disk.
    /// - Parameters:
    ///   - passURL: The file URL of the unsigned pass directory.
    ///   - destination: The destination URL for the signed `.pkpass` file, or `nil` to sign in place.
    ///   - options: Options that configure the behavior of the signing process.
    /// - Returns: The URL of the signed pass.
    /// - Throws: ``PassSigningError`` if signing fails, or an error if a file exists at `destination`
    ///   and `options` doesn't contain ``PassSigner/SigningOptions/overwriteExisting``.
    public func signPass(
        at passURL: URL,
        destination: URL?,
        options: SigningOptions = .default
    ) async throws -> URL {
        let workingURL = determineWritingDestination(passURL: passURL, outputURL: destination)

        if destination != nil {
            try workingURL.prepareForWriting(options: options)
            try workingURL.appendingPathExtension(PKPassFileSuffix).prepareForWriting(options: options)
            try fileManager._copyItem(at: passURL, to: workingURL)
        }

        try writeToolingVersion(to: workingURL)

        // Generate the manifest.
        let manifestGenerator = DiskManifestGenerator()
        let manifestFile = try await manifestGenerator.generateManifest(of: workingURL)

        // Generate the manifest signature.
        let signatureGenerator = ManifestSignatureGenerator(
            passCertificate: passCertificate,
            wwdrCertificate: wwdrCertificate
        )
        let signatureFile = try signatureGenerator.generateSignature(for: manifestFile)

        try manifestFile.write(
            to: workingURL.appending(path: "manifest.json"),
            originalContentsURL: nil
        )
        try signatureFile.write(
            to: workingURL.appending(path: "signature"),
            originalContentsURL: nil
        )

        // Clean up any working files when we exit.
        defer { try? fileManager.removeItem(at: workingURL) }

        if options.contains(.zipOutput) {
            let passURL = try await compressBundle(at: workingURL)
            return passURL
        } else {
            return workingURL
        }
    }

    private func determineWritingDestination(passURL: URL, outputURL: URL?) -> URL {
        let outputURL = outputURL ?? passURL

        if outputURL.pathExtension == PKPassFileSuffix {
            return outputURL.deletingPathExtension()
        } else {
            return outputURL
        }
    }

    private func writeToolingVersion(to packageURL: URL) throws {
        let toolingURL = packageURL.appendingPathComponent(toolingJSONFileName)

        var toolingVersion: Tooling
        if fileManager.fileExists(atPath: toolingURL.path) {
            let data = try Data(contentsOf: toolingURL)
            let decoder = PassJSONDecoder()
            toolingVersion = try decoder.decode(Tooling.self, from: data)
        } else {
            toolingVersion = Tooling()
        }
        toolingVersion.builderVersion = BuilderVersionString

        let encoder = PassJSONEncoder()
        let encoded = try encoder.encode(toolingVersion)
        try encoded.write(to: toolingURL)
    }

    private func compressBundle(at url: URL) async throws -> URL {
        let outputURL = url.appendingPathExtension(PKPassFileSuffix)
        let zipper = Zipper(inputURL: url, outputURL: outputURL, deleteOriginalInputOnSuccess: true)
        try await zipper.run()
        return outputURL
    }

    private var fileManager = FileManager.default
}

extension PassSigner {
    public struct SigningOptions: OptionSet, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let `default`: SigningOptions = [.zipOutput]

        /// Compresses the final output as a `.pkpass` archive. Set this option for distribution; clear it
        /// during integration testing to inspect the raw, unzipped output.
        public static let zipOutput = SigningOptions(rawValue: 1 << 0)

        /// Replaces any existing file at the output URL.
        public static let overwriteExisting = SigningOptions(rawValue: 1 << 1)
    }

    enum PassSignerError: Error, CustomStringConvertible {
        case fileAlreadyExistsAtOutputURL

        var description: String {
            switch self {
            case .fileAlreadyExistsAtOutputURL:
                """
                File exists at the output URL. Remove the file or set `overwriteExisting` to `true`.
                """
            }
        }
    }
}

private extension URL {
    func prepareForWriting(
        options: PassSigner.SigningOptions
    ) throws {
        guard FileManager.default.fileExists(atPath: path) else {
            return
        }

        if options.contains(.overwriteExisting) {
            try FileManager.default.removeItem(at: self)
        } else {
            throw PassSigner.PassSignerError.fileAlreadyExistsAtOutputURL
        }
    }
}

private extension FileManager {
    func _copyItem(at source: URL, to destination: URL) throws {
        // Call `NSFileManager/copyItem(at:to:)` and catch the error to workaround:
        // https://github.com/swiftlang/swift-foundation/issues/1125
        do {
            try copyItem(at: source, to: destination)
        } catch let error as CocoaError {
            // In Swift 6 on Linux, `FileManager/copyItems(at:to:)` raises an error _after_ successfully copying the
            // files when it's moving over file attributes from the source to the destination.
            // To workaround this issue, we check if the destination exist and the error wasn't that the destination
            // _already_ existed.
            if error.code != CocoaError.Code.fileWriteFileExists, fileExists(atPath: destination.path) {
                // Ignore this error.
                // The consequence is that the copied item may have some different attributes (creation date, owner,
                // etc.) compared to the source. These attributes aren't critical for copying input files over to
                // the output documentation archive.
                return
            }

            // Otherwise, if this was any other error or if the destination file doesn't exist after calling
            // `FileManager/copyItems(at:to:)`, re-throw the error to the caller.
            throw error
        }
    }
}
