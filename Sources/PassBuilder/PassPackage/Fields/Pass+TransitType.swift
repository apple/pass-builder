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
    enum TransitType: String, CaseIterable, Codable, Sendable {
        case air = "PKTransitTypeAir"
        case boat = "PKTransitTypeBoat"
        case bus = "PKTransitTypeBus"
        case generic = "PKTransitTypeGeneric"
        case train = "PKTransitTypeTrain"
    }
}

extension Pass.TransitType: Identifiable {
    public var id: String { rawValue }
}
