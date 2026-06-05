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
    enum TextAlignment: String, CaseIterable, Codable, Equatable, Sendable {
        case natural = "PKTextAlignmentNatural"
        case left = "PKTextAlignmentLeft"
        case center = "PKTextAlignmentCenter"
        case right = "PKTextAlignmentRight"
    }
}

extension Pass.TextAlignment: Identifiable {
    public var id: String { rawValue }
}
