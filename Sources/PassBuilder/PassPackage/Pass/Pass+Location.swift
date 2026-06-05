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
    /// An object that represents a location that the system uses to show a relevant pass.
    struct Location: Codable, Equatable, Sendable {
        /// The altitude, in meters, of the location.
        public var altitude: Double?

        /// (Required) The latitude, in degrees, of the location.
        public var latitude: Double?

        /// (Required) The longitude, in degrees, of the location.
        public var longitude: Double?

        /// The text to display on the lock screen when the pass is relevant. For example, a description of a
        /// nearby location, such as “Store nearby on 1st and Main”.
        public var relevantText: String?
    }
}
