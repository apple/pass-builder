//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.TextAlignment {
    init(protobuf: PBPassTextAlignment) throws {
        switch protobuf {
        case .textAlignmentNatural: self = .natural
        case .textAlignmentLeft: self = .left
        case .textAlignmentCenter: self = .center
        case .textAlignmentRight: self = .right
        default: throw ProtobufError.invalidValue(message: "PassTextAlignment type is not recognized.")
        }
    }
}
