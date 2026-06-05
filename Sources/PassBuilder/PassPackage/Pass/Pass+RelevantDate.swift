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
    /// An object that represents a date interval that the system uses to show a relevant pass.
    struct RelevantDate: Codable, Equatable, Sendable {
        /// The date and time when the pass becomes relevant.
        /// Wallet automatically calculates a relevancy interval from this date.
        public var date: Date?

        /// The date and time for the pass relevancy interval to end.
        public var endDate: Date?

        /// The date and time for the pass relevancy interval to begin.
        public var startDate: Date?
    }
}
