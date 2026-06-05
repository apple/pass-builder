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
    /// An object that represents the identification of a seat for a transit journey or an event.
    struct Seat: Equatable, Codable, Identifiable, Sendable {
        /// A description of the seat, such as A flat bed seat.
        public var seatDescription: String?

        /// The identifier code for the seat.
        public var seatIdentifier: String?

        /// The number of the seat.
        public var seatNumber: String?

        /// The row that contains the seat.
        public var seatRow: String?

        /// The section that contains the seat.
        public var seatSection: String?

        /// The aisle that contains the seat.
        public var seatAisle: String?

        /// The level that contains the seat.
        public var seatLevel: String?

        /// The type of seat, such as Reserved seating.
        public var seatType: String?

        /// A color associated with identifying the seat.
        public var seatSectionColor: Pass.Color?

        public init() {}

        /// An ID for the seat.
        @_spi(PassDesigner)
        public var id: ItemID {
            get { _id }
            set { _id = newValue }
        }

        @CodableDefault var _id = ItemID()
    }
}
