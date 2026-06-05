//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation
import Crypto

extension Data {
    private static let hexTable: [UInt8] = Array("0123456789abcdef".utf8)

    func sha1Hash() -> String {
        let digest = Insecure.SHA1.hash(data: self)
        let byteCount = Insecure.SHA1.byteCount
        return String(unsafeUninitializedCapacity: byteCount * 2) { buffer in
            var index = 0
            for byte in digest {
                // Split each byte into high and low nibbles to get two hex characters
                buffer[index] = Self.hexTable[Int(byte >> 4)]
                buffer[index + 1] = Self.hexTable[Int(byte & 0x0F)]
                index += 2
            }
            return byteCount * 2
        }
    }
}
