//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass.UpcomingPassInformationEntry {
    /// Information about the start and end time of the upcoming pass information entry.
    struct DateInformation: Codable, Equatable, Sendable {
        /// The start date of the upcoming pass information entry. If omitted, the entry lists the Time and Date as TBD.
        public var date: Date?

        /// A Boolean value that indicates whether the entry ignores the time components of the date.
        public var ignoreTimeComponents: Bool?

        /// A Boolean value that indicates whether the entry spans the entire day and the time components are ignored.
        public var isAllDay: Bool?

        /// A Boolean value that indicates whether the provided time of the event hasn’t been announced (commonly referred to as TBA).
        public var isUnannounced: Bool?

        /// A Boolean value that indicates whether the provided time of the event hasn’t been determined (commonly referred to as TBD).
        public var isUndetermined: Bool?

        /// The time zone to adjust the date into. If omitted, the entry uses the current time zone of the device.
        public var timeZone: String?
    }
}
