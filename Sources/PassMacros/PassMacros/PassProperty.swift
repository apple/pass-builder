//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

@_exported import PassPropertyProtocol

@freestanding(expression)
public macro passProperty<Value>(
    _ value: Value
) -> PassProperty<Value> = #externalMacro(
    module: "PassMacrosImpl",
    type: "PassPropertyMacro"
)

@freestanding(expression)
public macro propertyEmpty(
    _ value: String?
) -> Bool = #externalMacro(
    module: "PassMacrosImpl",
    type: "PropertyStringEmptyMacro"
)

@freestanding(expression)
public macro propertyEmpty<T>(
    _ value: [T]?
) -> Bool = #externalMacro(
    module: "PassMacrosImpl",
    type: "PropertyArrayEmptyMacro"
)

@freestanding(expression)
public macro propertyEmpty<T>(
    _ value: T?
) -> Bool = #externalMacro(
    module: "PassMacrosImpl",
    type: "PropertyOptionalEmptyMacro"
)
