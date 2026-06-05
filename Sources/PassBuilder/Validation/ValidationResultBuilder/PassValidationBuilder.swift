//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A result builder that constructs an array of validation issues.
@resultBuilder
public struct PassValidationBuilder {
    public static func buildBlock() -> [PassValidationIssue] {
        []
    }

    public static func buildBlock(_ components: PassValidationIssue...) -> [PassValidationIssue] {
        return components
    }

    public static func buildEither(first component: [PassValidationIssue]) -> [PassValidationIssue] {
        component
    }

    public static func buildEither(second component: [PassValidationIssue]) -> [PassValidationIssue] {
        component
    }

    public static func buildLimitedAvailability(_ component: [PassValidationIssue]) -> [PassValidationIssue] {
        component
    }

    public static func buildOptional(_ component: [PassValidationIssue]?) -> [PassValidationIssue] {
        component ?? []
    }

    public static func buildArray(_ components: [[PassValidationIssue]]) -> [PassValidationIssue] {
        components.reduce(into: []) { $0.append(contentsOf: $1) }
    }

    public static func buildBlock(_ components: [PassValidationIssue]...) -> [PassValidationIssue] {
        components.reduce(into: []) { $0.append(contentsOf: $1) }
    }

    public static func buildExpression(_ expression: [PassValidationIssue]) -> [PassValidationIssue] {
        expression
    }

    public static func buildExpression(_ expression: PassValidationIssue?) -> [PassValidationIssue] {
        if let expression {
            [expression]
        } else {
            []
        }
    }
}
