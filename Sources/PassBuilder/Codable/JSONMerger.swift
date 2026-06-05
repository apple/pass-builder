//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

struct JSONMerger<Value: Codable> {
    var codableObject: Value

    func merge(into originalJSONData: Data?) throws -> Data {
        let encoder = PassJSONEncoder()
        let decoder = PassJSONDecoder()

        let newData = try encoder.encode(codableObject)

        guard let originalJSONData else {
            return newData
        }

        var original = try decoder.decode([String: AnyCodable].self, from: originalJSONData)
        let new = try decoder.decode([String: AnyCodable].self, from: newData)

        // Remove keys that exist in the new object from original
        let mirror = Mirror(reflecting: codableObject)
        mirror.children.compactMap(\.label).forEach { original.removeValue(forKey: $0) }

        // Merge new into original, filtering nulls
        original.merge(new.filter { $0.value.value != nil }) { _, new in new }

        return try encoder.encode(original)
    }
}

// Required as JSONSerialization does not exist in FoundationEssentials.
private struct AnyCodable: Codable {
    let value: Any?

    init(value: Any?) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = nil
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map(\.value)
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues(\.value)
        } else {
            value = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case nil:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any?]:
            try container.encode(array.map { AnyCodable(value: $0) })
        case let dict as [String: Any?]:
            try container.encode(dict.mapValues { AnyCodable(value: $0) })
        default:
            try container.encodeNil()
        }
    }
}
