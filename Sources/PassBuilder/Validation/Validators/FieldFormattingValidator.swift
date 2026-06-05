//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

struct FieldFormattingValidator: PassValidationPlugin {
    func shouldValidatePackage(_ package: PassPackage) -> Bool {
        true
    }

    @PassValidationBuilder
    func validatePackage(_ package: PassPackage) -> [PassValidationIssue] {
        validatePassFields(style: .storeCard, fields: package.pass.storeCard)
        validatePassFields(style: .coupon, fields: package.pass.coupon)
        validatePassFields(style: .eventTicket, fields: package.pass.eventTicket)
        validatePassFields(style: .generic, fields: package.pass.generic)
        validatePassFields(style: .boardingPass, fields: package.pass.boardingPass)
        validatePassFields(style: .posterGeneric, fields: package.pass.posterGeneric)
    }

    @PassValidationBuilder
    func validatePassFields(style: PassStyle, fields: Pass.Fields?) -> [PassValidationIssue] {
        validateField(style: style, fields: fields?.headerFields)
        validateField(style: style, fields: fields?.primaryFields)
        validateField(style: style, fields: fields?.secondaryFields)
        validateField(style: style, fields: fields?.auxiliaryFields)
        validateField(style: style, fields: fields?.footerFields)
        validateField(style: style, fields: fields?.backFields)
    }

    func validateField(style: PassStyle, fields: [Pass.FieldContent]?) -> [PassValidationIssue] {
        let fields = fields ?? []

        let issues = fields.compactMap { field in
            if field.currencyCode != nil && field.numberStyle != nil {
                return PassValidationIssue(
                    severity: .warning,
                    domain: .editField(style: style),
                    domainItemID: field.id,
                    property: #passProperty(field.currencyCode),
                    message: "VALIDATION_ISSUE_CURRENCY_CODE_AND_NUMBER_FORMATTER"
                )
            }

            return nil
        }

        return issues
    }
}
