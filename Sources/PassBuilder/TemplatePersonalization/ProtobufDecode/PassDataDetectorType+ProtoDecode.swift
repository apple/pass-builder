//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.DataDetectorType {
    init(protobuf: PBPassDataDetectorType) throws {
        switch protobuf {
        case .dataDetectorTypePhoneNumber: self = .phoneNumber
        case .dataDetectorTypeLink: self = .link
        case .dataDetectorTypeAddress: self = .address
        case .dataDetectorTypeCalendarEvent: self = .calendarEvent
        default: throw ProtobufError.invalidValue(message: "PassDataDetectorType type is not recognized.")
        }
    }
}
