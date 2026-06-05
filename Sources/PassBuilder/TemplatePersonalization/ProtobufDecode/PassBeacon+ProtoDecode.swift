//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.Beacon {
    init(protobuf: PBPassBeacon) {
        proximityUUID = protobuf.proximityUuid

        if protobuf.hasMajor {
            major = UInt16(protobuf.major)
        }

        if protobuf.hasMinor {
            minor = UInt16(protobuf.minor)
        }

        if protobuf.hasRelevantText {
            relevantText = protobuf.relevantText
        }
    }
}
