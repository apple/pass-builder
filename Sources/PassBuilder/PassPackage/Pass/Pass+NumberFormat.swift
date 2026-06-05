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
    enum NumberFormat: String, CaseIterable, Equatable, Identifiable, Codable, Sendable {
        case decimal = "PKNumberStyleDecimal"
        case percent = "PKNumberStylePercent"
        case scientific = "PKNumberStyleScientific"
        case spellOut = "PKNumberStyleSpellOut"

        public var id: String { rawValue }
    }
}
