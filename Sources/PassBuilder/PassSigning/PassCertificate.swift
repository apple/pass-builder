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
import X509
internal import SwiftASN1

/// A certificate that signs or identifies a pass.
///
/// `PassCertificate` loads certificates from PKCS#12 (`.p12`) and DER-encoded files.
public struct PassCertificate {
    /// The parsed certificate.
    public var certificate: Certificate

    /// The PKCS12 bundle.
    var pkcs12Bundle: NIOSSLPKCS12Bundle?

    /// The format the certificate was loaded from.
    public var certificateType: PassCertificateType

    /// Creates a pass certificate by loading it from the specified file URL.
    ///
    /// - Parameters:
    ///   - certificateURL: The file URL of the certificate to load.
    ///   - password: The password for a PKCS#12 bundle, or `nil` if the file isn't password-protected.
    /// - Throws: ``PassSigningError/badPassword`` if the supplied password doesn't unlock the bundle,
    ///   ``PassSigningError/certificateChainEmpty`` if the bundle contains no certificates, or
    ///   ``PassSigningError/certificateInvalid`` if the file isn't a recognized PKCS#12 or DER certificate.
    public init(url certificateURL: URL, password: String? = nil) throws {
        #if os(macOS)
        _ = certificateURL.startAccessingSecurityScopedResource()
        defer { certificateURL.stopAccessingSecurityScopedResource() }
        #endif

        do {
            let (certificate, pkcs12Bundle) = try Self.p12Certificate(from: certificateURL, password: password)
            self.certificate = certificate
            self.pkcs12Bundle = pkcs12Bundle
            self.certificateType = .p12
            return
        } catch BoringSSLError.unknownError(let stack) {
            let isBadPassword = stack.contains(where: { $0.description.contains("INCORRECT_PASSWORD") })
            if isBadPassword {
                throw PassSigningError.badPassword
            }
        }

        let derCert = try? Self.derCertificate(from: certificateURL)
        if let derCert {
            certificate = derCert
            certificateType = .der
            return
        }

        throw PassSigningError.certificateInvalid
    }

    private static func p12Certificate(from url: URL, password: String?) throws -> (Certificate, NIOSSLPKCS12Bundle) {
        let passphrase = password.map { Array($0.utf8) }
        let pkcs12Bundle = try NIOSSLPKCS12Bundle(file: url.path, passphrase: passphrase)

        guard let nioSigningCert = pkcs12Bundle.certificateChain.first else {
            throw PassSigningError.certificateChainEmpty
        }

        let signingCert = try Certificate(derEncoded: nioSigningCert.toDERBytes())
        return (signingCert, pkcs12Bundle)
    }

    private static func derCertificate(from url: URL) throws -> Certificate {
        let certificateData = try Data(contentsOf: url)
        let certificate = try Certificate(derEncoded: Array(certificateData))
        return certificate
    }
}

extension PassCertificate {
    /// The certificate type.
    public enum PassCertificateType: Sendable {
        /// A `.p12` file, valid for signing passes.
        case p12
        /// A DER file that contains pass type ID metadata, but isn't valid for signing passes.
        case der
    }
}
