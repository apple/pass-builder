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
    /// A distance, in meters, expressed as a numeric value.
    ///
    /// Wallet requires distance values such as `maxDistance` to be JSON numbers.
    /// Some pass generators incorrectly emit them as strings (e.g. `"100"`),
    /// which Wallet silently discards. ``Distance`` decodes strictly — it accepts
    /// only a JSON number and throws ``DecodingError/mustBeANumber`` otherwise —
    /// so the editor can surface the mistake instead of dropping the value.
    struct Distance: Equatable, Sendable {
        /// The distance in meters.
        public var meters: Double

        public init(meters: Double) {
            self.meters = meters
        }
    }
}

extension Pass.Distance: Codable {
    public enum DecodingError: Error, Equatable {
        case mustBeANumber
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let value = try? container.decode(Double.self) else {
            throw DecodingError.mustBeANumber
        }
        meters = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(meters)
    }
}

extension Pass.Distance: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(meters: value)
    }
}

extension Pass.Distance: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(meters: Double(value))
    }
}
