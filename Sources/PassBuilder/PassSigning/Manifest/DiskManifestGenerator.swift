//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// Generate the manifest for a pass.
struct DiskManifestGenerator {
    enum ManifestError: Error {
        case cannotCreateEnumerator
    }

    /// Generate the manifest of the pass.
    /// - Parameter passURL: The URL of the pass.
    /// - Returns: The manifest of the pass.
    func generateManifest(of passURL: URL) async throws -> FileWrapperContainer.FileWrapperType {
        let manifest = try await manifestDictionary(from: passURL)
        let manifestData = try JSONEncoder().encode(manifest)
        let manifestFile = FileWrapperContainer.FileWrapperType(regularFileWithContents: manifestData)
        manifestFile.filename = "manifest.json"
        return manifestFile
    }

    private func manifestDictionary(from passURL: URL) async throws -> [String: String] {
        let fileURLs = try collectRegularFiles(in: passURL)

        let count = fileURLs.count
        guard count > 0 else {
            return [:]
        }

        let relativePaths = try fileURLs.map { try $0.relativePath(to: passURL) }

        return try await withThrowingTaskGroup(of: (Int, String).self) { group in
            for index in 0..<count {
                group.addTask {
                    let data = try Data(contentsOf: fileURLs[index], options: .mappedIfSafe)
                    return (index, data.sha1Hash())
                }
            }

            var manifest = [String: String](minimumCapacity: count)
            for try await (index, hash) in group {
                manifest[relativePaths[index]] = hash
            }
            return manifest
        }
    }

    private func collectRegularFiles(in directoryURL: URL) throws -> [URL] {
        let fileManager = FileManager.default

        guard
            let resourceValues = try? directoryURL.resourceValues(forKeys: [.isDirectoryKey]),
            resourceValues.isDirectory == true
        else {
            throw ManifestError.cannotCreateEnumerator
        }

        guard let enumerator = fileManager.enumerator(
            at: directoryURL,
            includingPropertiesForKeys: [.isRegularFileKey, .isSymbolicLinkKey]
        ) else {
            throw ManifestError.cannotCreateEnumerator
        }

        var fileURLs: [URL] = []
        for case let fileURL as URL in enumerator {
            let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])

            guard resourceValues.isSymbolicLink != true else { continue }

            if resourceValues.isRegularFile == true {
                fileURLs.append(fileURL)
            }
        }
        return fileURLs
    }
}

extension URL {
    // Workaround due to: https://github.com/swiftlang/swift-corelibs-foundation/issues/5282
    func relativePath(to containingURL: URL) throws -> String {
        let base = containingURL.resolvingSymlinksInPath()
        let target = self.resolvingSymlinksInPath()

        let basePath = base.path.hasSuffix("/") ? base.path : base.path + "/"

        guard target.path.hasPrefix(basePath) || target.path == base.path else {
            throw DiskManifestGenerator.ManifestError.cannotCreateEnumerator
        }

        return String(target.path.dropFirst(basePath.count))
    }
}
