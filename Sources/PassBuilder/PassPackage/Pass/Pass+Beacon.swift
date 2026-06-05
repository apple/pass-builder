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
    /// An object that represents the identifier of a Bluetooth Low Energy beacon the system uses to show a
    /// relevant pass.
    struct Beacon: Codable, Equatable, Sendable {
        /// The major identifier of a Bluetooth Low Energy location beacon.
        var major: UInt16?

        /// The minor identifier of a Bluetooth Low Energy location beacon.
        var minor: UInt16?

        /// (Required) The unique identifier of a Bluetooth Low Energy location beacon.
        var proximityUUID: String?

        /// The text to display on the lock screen when the pass is relevant.
        /// For example, a description of a nearby location.
        var relevantText: String?
    }
}
