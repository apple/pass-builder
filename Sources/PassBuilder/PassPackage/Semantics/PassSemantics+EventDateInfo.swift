//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass.Semantics {
    /// An object that represents a date for an event.
    struct EventDateInfo: Codable, Equatable, Sendable {
        /// The date.
        public var date: String?

        /// A Boolean value that indicates whether the system ignores the time components of the date.
        public var ignoreTimeComponents: Bool?

        /// The time zone to display in the date.
        public var timeZone: String?

        /// A Boolean value that indicates whether the date of the event is unannounced.
        public var unannounced: Bool?

        /// A Boolean value that indicates whether the date of the event is undetermined.
        public var undetermined: Bool?
    }
}
