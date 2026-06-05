//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A property wrapper that skips encoding and decoding of a property in `Codable` types.
@propertyWrapper
struct CodableIgnoring<T: DefaultCodingProvider>: Codable, Equatable, Sendable {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        self.wrappedValue = T.defaultValue
    }

    func encode(to encoder: Encoder) throws {}
}

extension KeyedDecodingContainer {
    func decode<T>(
        _ type: CodableIgnoring<T>.Type,
        forKey key: Self.Key
    ) throws -> CodableIgnoring<T> {
        return CodableIgnoring(wrappedValue: .defaultValue)
    }
}

extension KeyedEncodingContainer {
    mutating func encode<T>(
        _ value: CodableIgnoring<T>,
        forKey key: KeyedEncodingContainer<K>.Key
    ) throws {

    }
}
