//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

struct EventTicketValidator: PassValidationPlugin {
    func shouldValidatePackage(_ package: PassPackage) -> Bool {
        let pass = package.pass
        return pass.eventTicket != nil && pass.supportSemanticDrivenPassStyle
    }

    @PassValidationBuilder
    func validatePackage(_ package: PassPackage) -> [PassValidationIssue] {
        let pass = package.pass

        if #propertyEmpty(pass.nfc) {
            PassValidationIssue(
                severity: .error,
                domain: .barcodeNFC,
                property: #passProperty(pass.nfc),
                message: "PASS_VALIDATION_EVENT_MISSING_NFC"
            )
        }

        if let nfc = pass.nfc, #propertyEmpty(nfc.requiresAuthentication) {
            PassValidationIssue(
                severity: .error,
                domain: .barcodeNFC,
                property: #passProperty(nfc.requiresAuthentication),
                message: "PASS_VALIDATION_EVENT_MISSING_NFC_AUTH"
            )
        }

        let semantics = pass.semantics

        if #propertyEmpty(semantics?.eventName) {
            PassValidationIssue(
                severity: .error,
                domain: .eventDetails,
                property: #passProperty(semantics?.eventName),
                message: "PASS_VALIDATION_EVENT_MISSING_EVENT_NAME"
            )
        }

        if #propertyEmpty(semantics?.venueName) {
            PassValidationIssue(
                severity: .error,
                domain: .eventDetails,
                property: #passProperty(semantics?.venueName),
                message: "PASS_VALIDATION_EVENT_MISSING_VENUE_NAME"
            )
        }

        if #propertyEmpty(semantics?.eventStartDate) {
            PassValidationIssue(
                severity: .warning,
                domain: .eventDetails,
                property: #passProperty(semantics?.eventStartDate),
                message: "PASS_VALIDATION_EVENT_MISSING_START_DATE"
            )
        }

        if let startDate = semantics?.eventStartDate,
           let endDate = semantics?.eventEndDate,
           startDate > endDate {
            PassValidationIssue(
                severity: .warning,
                domain: .eventDetails,
                property: #passProperty(semantics?.eventEndDate),
                message: "PASS_VALIDATION_EVENT_START_AFTER_END"
            )
        }

        if semantics?.eventType == .sports {
            validateSports(in: pass)
        }

        if semantics?.eventType == .livePerformance {
            validateLivePerformance(in: pass)
        }

        validateImages(in: package)
    }

    @PassValidationBuilder
    func validateSports(in pass: Pass) -> [PassValidationIssue] {
        let semantics = pass.semantics
        if #propertyEmpty(semantics?.awayTeamAbbreviation) {
            PassValidationIssue(
                severity: .error,
                domain: .eventSport,
                property: #passProperty(semantics?.awayTeamAbbreviation),
                message: "PASS_VALIDATION_EVENT_MISSING_AWAY_TEAM_ABBREVIATION"
            )
        }

        if #propertyEmpty(semantics?.homeTeamAbbreviation) {
            PassValidationIssue(
                severity: .error,
                domain: .eventSport,
                property: #passProperty(semantics?.homeTeamAbbreviation),
                message: "PASS_VALIDATION_EVENT_MISSING_HOME_TEAM_ABBREVIATION"
            )
        }
    }

    @PassValidationBuilder
    func validateLivePerformance(in pass: Pass) -> [PassValidationIssue] {
        let semantics = pass.semantics

        if #propertyEmpty(semantics?.performerNames) {
            PassValidationIssue(
                severity: .error,
                domain: .eventLivePerformance,
                property: #passProperty(semantics?.performerNames),
                message: "PASS_VALIDATION_EVENT_MISSING_LIVE_PERFORMERS"
            )
        }

        if #propertyEmpty(semantics?.artistIDs) {
            PassValidationIssue(
                severity: .warning,
                domain: .eventLivePerformance,
                property: #passProperty(semantics?.artistIDs),
                message: "PASS_VALIDATION_EVENT_MISSING_ARTIST_IDS"
            )
        }
    }

    @PassValidationBuilder
    func validateImages(in package: PassPackage) -> [PassValidationIssue] {
        if !(package.background.hasImage || package.artwork.hasImage) {
            if !package.artwork.hasImage {
                PassValidationIssue(
                    severity: .error,
                    domain: .images,
                    property: #passProperty(package.artwork),
                    message: "PASS_VALIDATION_EVENT_MISSING_ARTWORK_IMAGE"
                )
            } else if !package.background.hasImage {
                PassValidationIssue(
                    severity: .error,
                    domain: .images,
                    property: #passProperty(package.background),
                    message: "PASS_VALIDATION_EVENT_MISSING_BACKGROUND_IMAGE"
                )
            }
        }
    }
}
