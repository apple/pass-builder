//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation
import NIOSSL
@_spi(CMS) import X509
internal import SwiftASN1

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

/// Sign the manifest of a pass.
struct ManifestSignatureGenerator {
    /// The certificate to sign the pass.
    /// This should correspond to the `passTypeIdentifier` specified in the pass.json.
    var passCertificate: PassCertificate

    /// The WWDR intermediate certificate.
    var wwdrCertificate: PassCertificate

    /// Sign the manifest.
    func generateSignature(
        for manifestFile: FileWrapperContainer.FileWrapperType
    ) throws -> FileWrapperContainer.FileWrapperType {
        guard passCertificate.certificateType == .p12, let pkcs12Bundle = passCertificate.pkcs12Bundle else {
            throw PassSigningError.certificateInvalid
        }

        let privateKey = try privateKey(from: pkcs12Bundle)

        guard let manifestFileContents = manifestFile.regularFileContents else {
            throw PassSigningError.unknownError(output: "No manifest data to sign.")
        }

        // Create a CMS detached signature (detached: true is the default.)
        let signatureBytes = try CMS.sign(
            manifestFileContents,
            additionalIntermediateCertificates: [wwdrCertificate.certificate],
            certificate: passCertificate.certificate,
            privateKey: privateKey,
            signingTime: Date()
        )

        let signatureData = Data(signatureBytes)

        let fileWrapper = FileWrapperContainer.FileWrapperType(regularFileWithContents: signatureData)
        fileWrapper.preferredFilename = "signature"
        return fileWrapper
    }

    // MARK: - Private

    /// Converts an `NIOSSLPrivateKey` to a `Certificate.PrivateKey` without passing through a
    /// `String`. The DER buffer is zeroed before returning to minimize the window in which raw
    /// key material is present in process memory.
    private func privateKey(from pkcs12Bundle: NIOSSLPKCS12Bundle) throws -> Certificate.PrivateKey {
        var keyDER = try pkcs12Bundle.privateKey.derBytes

        defer {
            let count = keyDER.count
            keyDER.withUnsafeMutableBytes { ptr in
                guard let base = ptr.baseAddress else { return }
                #if canImport(Darwin)
                _ = memset_s(base, count, 0, count)
                #else
                explicit_bzero(base, count)
                #endif
            }
        }

        // Try EC (SEC1) first.
        if let ecKey = try? Certificate.PrivateKey(
            pemDocument: PEMDocument(type: "EC PRIVATE KEY", derBytes: keyDER)
        ) {
            return ecKey
        }

        // Fall back to RSA (PKCS#1).
        return try Certificate.PrivateKey(
            pemDocument: PEMDocument(type: "RSA PRIVATE KEY", derBytes: keyDER)
        )
    }
}
