//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A plugin that validates a pass.
public protocol PassValidationPlugin {
    /// Returns a Boolean value that indicates whether to run this validator on the given package.
    /// - Parameter package: The package to validate.
    /// - Returns: A Boolean value that indicates whether to run the validator on the package.
    func shouldValidatePackage(_ package: PassPackage) -> Bool

    /// Returns the issues found with the pass.
    @PassValidationBuilder func validatePackage(_ package: PassPackage) -> [PassValidationIssue]
}
