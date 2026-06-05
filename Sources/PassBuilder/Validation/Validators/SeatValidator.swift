//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

struct SeatValidator: PassValidationPlugin {
    func shouldValidatePackage(_ package: PassPackage) -> Bool {
        let pass = package.pass
        let isSeatStyle = pass.eventTicket != nil || pass.boardingPass != nil
        return isSeatStyle && pass.supportSemanticDrivenPassStyle
    }

    @PassValidationBuilder
    func validatePackage(_ package: PassPackage) -> [PassValidationIssue] {
        if #propertyEmpty(package.pass.semantics?.seats) {
            PassValidationIssue(
                severity: .warning,
                domain: .seats,
                property: #passProperty(package.pass.semantics?.seats),
                message: "PASS_VALIDATION_EVENT_MISSING_SEAT"
            )
        }
    }
}
