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
    enum DateTimeFormat: String, Codable, Equatable, Sendable {
        case none = "PKDateStyleNone"
        case short = "PKDateStyleShort"
        case medium = "PKDateStyleMedium"
        case long = "PKDateStyleLong"
        case full = "PKDateStyleFull"
    }
}
