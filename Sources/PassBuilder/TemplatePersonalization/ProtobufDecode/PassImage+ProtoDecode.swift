//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension PassImage {
    mutating func extractMessage(from protobuf: PBPassImageSet) throws {
        if protobuf.hasTimes1 {
            times1 = try PassImageFile(protobuf: protobuf.times1)
        }
        if protobuf.hasTimes2 {
            times2 = try PassImageFile(protobuf: protobuf.times2)
        }
        if protobuf.hasTimes3 {
            times3 = try PassImageFile(protobuf: protobuf.times3)
        }
    }
}
