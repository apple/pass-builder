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
    /// A pass action.
    struct Action: Equatable, Codable, Sendable {
        @CodableDefault var _id = ItemID()

        /// An ID for the action.
        @_spi(PassDesigner)
        public var id: ItemID {
            get { _id }
            set { _id = newValue }
        }

        /// (Required) A unique ID for the action.
        public var identifier: String?

        /// (Required) The action type to perform.
        public var type: String?

        /// The URL the action opens, if applicable.
        public var url: String?
    }
}
