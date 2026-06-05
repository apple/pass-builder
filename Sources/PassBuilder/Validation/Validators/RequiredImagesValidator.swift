//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

struct RequiredImagesValidator: PassValidationPlugin {
    func shouldValidatePackage(_ package: PassPackage) -> Bool {
        true
    }

    @PassValidationBuilder func validatePackage(_ package: PassPackage) -> [PassValidationIssue] {
        let hasIcon = package.icon.hasImage

        if hasIcon {
            if package.icon.times2 == nil {
                PassValidationIssue(
                    severity: .warning,
                    domain: .images,
                    fileName: package.$icon.name(for: \.times2),
                    message: """
                        VALIDATION_ISSUE_RECOMMENDED_IMAGE_NOT_PROVIDED
                        \(package.$icon.name(for: \.times2))
                        """
                )
            }

            if package.icon.times3 == nil {
                PassValidationIssue(
                    severity: .warning,
                    domain: .images,
                    fileName: package.$icon.name(for: \.times3),
                    message: """
                        VALIDATION_ISSUE_RECOMMENDED_IMAGE_NOT_PROVIDED
                        \(package.$icon.name(for: \.times3))
                        """
                )
            }
        } else {
            PassValidationIssue(
                severity: .error,
                domain: .images,
                fileName: package.$icon.name(for: \.times2),
                message: """
                    VALIDATION_ISSUE_REQUIRED_IMAGE_NOT_PROVIDED
                    \(package.$icon.name(for: \.times2))
                    """
            )

            PassValidationIssue(
                severity: .error,
                domain: .images,
                fileName: package.$icon.name(for: \.times3),
                message: """
                    VALIDATION_ISSUE_REQUIRED_IMAGE_NOT_PROVIDED
                    \(package.$icon.name(for: \.times3))
                    """
            )
        }
    }
}
