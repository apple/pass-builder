//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.RelevantDate {
    init(protobuf: PBPassRelevantDate) {
        if protobuf.hasDate {
            date = Date(timeIntervalSince1970: protobuf.date.timeIntervalSince1970)
        }

        if protobuf.hasStartDate {
            startDate = Date(timeIntervalSince1970: protobuf.startDate.timeIntervalSince1970)
        }

        if protobuf.hasEndDate {
            endDate = Date(timeIntervalSince1970: protobuf.endDate.timeIntervalSince1970)
        }
    }
}
