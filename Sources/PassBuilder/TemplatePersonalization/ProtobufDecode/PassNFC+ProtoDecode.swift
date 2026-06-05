//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.NFC {
    init(protobuf: PBPassNFC) {
        encryptionPublicKey = protobuf.encryptionPublicKey
        message = protobuf.message
        requiresAuthentication = protobuf.requiresAuthentication
    }
}
