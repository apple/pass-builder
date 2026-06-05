//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

/// A property of a pass.
///
/// Create instances using the `#passProperty` macro.
public struct PassProperty<Value> {
    /// The name of the property.
    public let name: String

    /// The value of the property.
    public let value: Value

    public init(
        name: String,
        value: Value
    ) {
        self.name = name
        self.value = value
    }
}
