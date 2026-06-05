//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

@propertyWrapper
struct CodableDefault<T: DefaultCodingProvider>: Codable, Equatable, Sendable {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(T.self)) ?? T.defaultValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(
        _ type: CodableDefault<T>.Type,
        forKey key: Self.Key
    ) throws -> CodableDefault<T> {
        do {
            let decodedItem = try self.decode(T.self, forKey: key)
            return CodableDefault(wrappedValue: decodedItem)
        } catch {
            return CodableDefault(wrappedValue: .defaultValue)
        }
    }
}
