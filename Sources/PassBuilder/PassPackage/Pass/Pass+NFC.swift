//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass {
    /// An object that represents the near-field communication (NFC) payload the device passes to an Apple Pay terminal.
    struct NFC: Equatable, Codable, Sendable {
        // Required. A Base64-encoded X.509 SubjectPublicKeyInfo containing an ECDH public key for curve secp256r1.
        // Include only the Base64 body of the PEM (exclude the BEGIN/END lines).
        // The public encryption key is used by the Value Added Services protocol.
        public var encryptionPublicKey: String = ""

        // Required. The payload the device transmits to the Apple Pay terminal. The size must be no more than 64 bytes.
        // The system truncates messages longer than 64 bytes.
        public var message: String = ""

        // A Boolean value that indicates whether the NFC pass requires authentication. The default value is false.
        // A value of true requires the user to authenticate for each use of the NFC pass. This key is valid in
        // iOS 13.1 and later. Set sharingProhibited to true to prevent users from sharing passes with older iOS
        // versions and bypassing the authentication requirement.
        public var requiresAuthentication: Bool?

        public init() {}
    }
}
