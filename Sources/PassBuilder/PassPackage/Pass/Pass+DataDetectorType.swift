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
    enum DataDetectorType: String, CaseIterable, Codable, Equatable, Sendable {
        case phoneNumber = "PKDataDetectorTypePhoneNumber"
        case link = "PKDataDetectorTypeLink"
        case address = "PKDataDetectorTypeAddress"
        case calendarEvent = "PKDataDetectorTypeCalendarEvent"
    }
}
