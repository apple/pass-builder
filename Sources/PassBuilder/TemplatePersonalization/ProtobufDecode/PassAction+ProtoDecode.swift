//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.Action {
    init(protobuf: PBPassAction) {
        identifier = protobuf.identifier
        type = protobuf.actionType
        url = protobuf.url
    }
}
