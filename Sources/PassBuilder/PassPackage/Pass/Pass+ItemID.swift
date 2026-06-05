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
    struct ItemID: Codable, Hashable, Sendable {
        public var id: UUID

        public init() {
            self.id = UUID()
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if !container.decodeNil() {
                self.id = try container.decode(UUID.self)
            } else {
                self.id = UUID()
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(id)
        }
    }
}

extension Pass.ItemID: CustomStringConvertible {
    public var description: String { id.description }
}

extension Pass.ItemID: DefaultCodingProvider {
    static var defaultValue: Self { Pass.ItemID() }
}
