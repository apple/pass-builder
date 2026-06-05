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

extension PassCertificate {
    /// The identity attributes extracted from this certificate's subject.
    public var attributes: Attributes {
        Attributes(certificate: certificate)
    }

    /// Identity attributes embedded in a pass certificate.
    public struct Attributes {
        /// The pass type identifier, such as `pass.com.example.ticket`, if present.
        public var passTypeID: String?

        /// The Apple Developer team identifier, if present.
        public var WWDRTeamID: String?

        init(certificate: Certificate) {
            passTypeID = queryAttribute(passTypeIDOID, in: certificate)
            WWDRTeamID = queryAttribute(WWDRTeamIDOID, in: certificate)
        }

        private func queryAttribute(_ oid: ASN1ObjectIdentifier, in certificate: Certificate) -> String? {
            for rdn in certificate.subject {
                for attribute in rdn {
                    guard attribute.type == oid else { continue }
                    return String(describing: attribute.value)
                }
            }
            return nil
        }

        /// Validates that the certificate's attributes match the given pass.
        ///
        /// - Parameter pass: The pass to validate against. If no error is thrown, the certificate is valid for the
        /// given pass.
        public func validateAttributes(for pass: Pass) throws {
            guard let WWDRTeamID, let passTypeID else {
                throw PassSigningError.certificateInvalid
            }

            guard
                pass.teamIdentifier == WWDRTeamID,
                pass.passTypeIdentifier == passTypeID
            else {
                throw PassSigningError.certificateAttributesMismatch(
                    teamID: WWDRTeamID,
                    passTypeID: passTypeID
                )
            }
        }
    }
}

private let passTypeIDOID: ASN1ObjectIdentifier = [0, 9, 2342, 19200300, 100, 1, 1]
private let WWDRTeamIDOID: ASN1ObjectIdentifier = [2, 5, 4, 11]
