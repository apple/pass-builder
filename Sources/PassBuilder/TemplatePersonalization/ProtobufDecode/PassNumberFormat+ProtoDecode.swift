//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.NumberFormat {
    init(protobuf: PBPassNumberFormat) throws {
        switch protobuf {
        case .numberFormatDecimal: self = .decimal
        case .numberFormatPercent: self = .percent
        case .numberFormatScientific: self = .scientific
        case .numberFormatSpellOut: self = .spellOut
        default: throw ProtobufError.invalidValue(message: "PassNumberFormat type is not recognized.")
        }
    }
}
