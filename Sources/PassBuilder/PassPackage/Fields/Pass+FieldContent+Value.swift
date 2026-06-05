//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass.FieldContent {
    /// The value type for a field, supporting text, dates, and numbers.
    enum Value: Equatable, Sendable {
        case text(String)
        case date(Date)
        case int(Int)
        case double(Double)

        /// The underlying type category of this value.
        public var type: ValueType {
            switch self {
            case .text: return .text
            case .date: return .date
            case .int: return .int
            case .double: return .double
            }
        }

        /// A Boolean value that indicates whether this value is a numeric type (`Int` or `Double`).
        public var isNumber: Bool {
            switch self {
            case .int, .double: return true
            case .text, .date: return false
            }
        }

        /// The value as a `String`, or `nil` if the value isn't text.
        public var textValue: String? {
            get {
                if case .text(let value) = self {
                    return value
                }
                return nil
            }
            set {
                if let newValue {
                    self = .text(newValue)
                }
            }
        }

        /// The value as a `Date`, or `nil` if the value isn't a date.
        public var dateValue: Date? {
            get {
                if case .date(let value) = self {
                    return value
                }
                return nil
            }
            set {
                if let newValue {
                    self = .date(newValue)
                }
            }
        }

        /// The value as an `Int`, or `nil` if the value isn't an integer.
        public var intValue: Int? {
            get {
                if case .int(let value) = self {
                    return value
                }
                return nil
            }
            set {
                if let newValue {
                    self = .int(newValue)
                }
            }
        }

        /// The value as a `Double`, or `nil` if the value isn't a double.
        public var doubleValue: Double? {
            get {
                if case .double(let value) = self {
                    return value
                }
                return nil
            }
            set {
                if let newValue {
                    self = .double(newValue)
                }
            }
        }
    }

    /// The type category of a field value.
    enum ValueType: Int, Equatable, CaseIterable, Codable, Identifiable {
        case text, date, int, double

        public var id: String { rawValue.description }
    }
}

extension Pass.FieldContent.Value: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let dateValue = try? container.decode(Date.self) {
            self = .date(dateValue)
            return
        }

        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
            return
        }

        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
            return
        }

        let stringValue = try container.decode(String.self)
        self = .text(stringValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .text(let value):
            try container.encode(value)
        case .date(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        }
    }
}

extension Pass.FieldContent.Value: DefaultCodingProvider {
    static var defaultValue: Self { .text("") }
}
