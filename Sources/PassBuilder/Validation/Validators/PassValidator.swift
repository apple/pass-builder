//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// An object that identifies potential issues with a pass.
public struct PassValidator {

    private var plugins: [PassValidationPlugin] = [
        EventTicketValidator(),
        SeatValidator(),
        BoardingPassValidator(),
        FieldFormattingValidator(),
        RequiredImagesValidator()
    ]

    public init() {}

    /// Registers a new plugin with the validator.
    /// - Parameter plugin: A plugin that validates a pass.
    public mutating func registerPlugin<Plugin: PassValidationPlugin>(_ plugin: Plugin) {
        plugins.append(plugin)
    }

    /// Validates a pass.
    /// - Parameter package: The pass bundle to validate.
    /// - Returns: A list of errors and warnings found in the pass. An empty list indicates the pass is valid.
    public func validate(_ package: PassPackage) -> PassValidationResult {
        let issues: [PassValidationIssue] = plugins
            .map { validator in
                if validator.shouldValidatePackage(package) {
                    return validator.validatePackage(package)
                } else {
                    return []
                }
            }
            .reduce(into: []) {
                $0.append(contentsOf: $1)
            }
        let result = PassValidationResult(issues: issues)
        return result
    }
}
