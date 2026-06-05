//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.Location {
    init(protobuf: PBPassLocation) {
        latitude = protobuf.latitude
        longitude = protobuf.longitude

        if protobuf.hasAltitude {
            altitude = protobuf.altitude
        }

        if protobuf.hasRelevantText {
            relevantText = protobuf.relevantText
        }
    }
}
