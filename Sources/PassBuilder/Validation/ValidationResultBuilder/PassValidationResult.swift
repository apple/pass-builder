//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// The outcome of validating a pass package, which contains any issues found during validation.
public struct PassValidationResult {
    /// The validation issues that the validator discovers during pass validation.
    public var issues: [PassValidationIssue]

    /// Creates a validation result with the specified issues.
    public init(issues: [PassValidationIssue]) {
        self.issues = issues
    }
}
