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
    enum EventType: String, Codable, Identifiable, Sendable, CaseIterable {
        case generic = "PKEventTypeGeneric"
        case livePerformance = "PKEventTypeLivePerformance"
        case movie = "PKEventTypeMovie"
        case sports = "PKEventTypeSports"
        case conference = "PKEventTypeConference"
        case convention = "PKEventTypeConvention"
        case workshop = "PKEventTypeWorkshop"
        case socialGathering = "PKEventTypeSocialGathering"

        public var id: String {
            rawValue
        }
    }
}
