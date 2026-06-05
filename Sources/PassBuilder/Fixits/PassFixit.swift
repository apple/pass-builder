//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A collection of automated corrections applied to a pass to ensure its properties
/// remain consistent and valid after editing.
///
/// Use `PassFixits` to reconcile conflicting or stale configuration that can arise
/// when switching pass styles, migrating deprecated properties, or editing field content.
///
/// ```swift
/// let fixits = PassFixits()
/// let correctedPass = fixits.fix(myPass)
/// ```
struct PassFixits {
    /// Applies all registered fix-its to the given pass and returns the corrected result.
    func fix(_ pass: Pass) -> Pass {
        var pass = pass

        var fixits = [
            fixDeprecatedBarcodes,
            fixPassFieldsContainingConflictingKeys
        ]

        fixits.forEach {
            $0(&pass)
        }

        return pass
    }

    /// Migrates the deprecated `barcode` property to the `barcodes` array.
    private func fixDeprecatedBarcodes(_ pass: inout Pass) {
        let barcodes = (pass.barcodes ?? []) + [pass.barcode].compactMap(\.self)
        pass.barcodes = barcodes.isEmpty ? nil : barcodes
    }

    /// Removes formatting properties from fields when they conflict with the field's value type.
    private func fixPassFieldsContainingConflictingKeys(_ pass: inout Pass) {
        fixStyleFieldsContainingConflictingKeys(&pass.coupon)
        fixStyleFieldsContainingConflictingKeys(&pass.storeCard)
        fixStyleFieldsContainingConflictingKeys(&pass.eventTicket)
        fixStyleFieldsContainingConflictingKeys(&pass.boardingPass)
        fixStyleFieldsContainingConflictingKeys(&pass.posterGeneric)
        fixStyleFieldsContainingConflictingKeys(&pass.generic)
    }

    private func fixStyleFieldsContainingConflictingKeys(_ fields: inout Pass.Fields?) {
        var fieldsCopy = fields
        fieldsCopy?.headerFields = fields?.headerFields?.map(cleanupField)
        fieldsCopy?.primaryFields = fields?.primaryFields?.map(cleanupField)
        fieldsCopy?.secondaryFields = fields?.secondaryFields?.map(cleanupField)
        fieldsCopy?.auxiliaryFields = fields?.auxiliaryFields?.map(cleanupField)
        fieldsCopy?.footerFields = fields?.footerFields?.map(cleanupField)
        fieldsCopy?.backFields = fields?.backFields?.map(cleanupField)
        fieldsCopy?.additionalInfoFields = fields?.additionalInfoFields?.map(cleanupField)
        fields = fieldsCopy
    }

    private func cleanupField(_ field: Pass.FieldContent) -> Pass.FieldContent {
        var field = field

        if field.value.type != .date {
            field.dateStyle = nil
            field.timeStyle = nil
            field.ignoresTimeZone = nil
            field.isRelative = nil
        }

        if !field.value.isNumber {
            field.numberStyle = nil
        }

        if field.currencyCode?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            field.currencyCode = nil
        }

        return field
    }
}

