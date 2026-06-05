//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.Seat {
    init(protobuf: PBPassSeat) {
        if !protobuf.seatDescription.isEmpty {
            seatDescription = protobuf.seatDescription
        }

        if !protobuf.seatIdentifier.isEmpty {
            seatIdentifier = protobuf.seatIdentifier
        }

        if !protobuf.seatNumber.isEmpty {
            seatNumber = protobuf.seatNumber
        }

        if !protobuf.seatRow.isEmpty {
            seatRow = protobuf.seatRow
        }

        if !protobuf.seatSection.isEmpty {
            seatSection = protobuf.seatSection
        }

        if !protobuf.seatAisle.isEmpty {
            seatAisle = protobuf.seatAisle
        }

        if !protobuf.seatLevel.isEmpty {
            seatLevel = protobuf.seatLevel
        }

        if !protobuf.seatType.isEmpty {
            seatType = protobuf.seatType
        }

        if protobuf.hasSeatSectionColor {
            seatSectionColor = Pass.Color(protobuf: protobuf.seatSectionColor)
        }
    }
}
