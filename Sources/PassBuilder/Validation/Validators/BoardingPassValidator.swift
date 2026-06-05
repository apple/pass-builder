//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

struct BoardingPassValidator: PassValidationPlugin {
    func shouldValidatePackage(_ package: PassPackage) -> Bool {
        let pass = package.pass
        return pass.boardingPass != nil && pass.supportSemanticDrivenPassStyle
    }

    @PassValidationBuilder
    func validatePackage(_ package: PassPackage) -> [PassValidationIssue] {
        let semantics = package.pass.semantics

        validateFlightPlan(semantics)
        validateDepartureAirport(semantics)
        validateArrivalAirport(semantics)

        if semantics?.passengerName?.isEmpty ?? true {
            PassValidationIssue(
                severity: .error,
                domain: .passengerDetails,
                property: #passProperty(semantics?.passengerName),
                message: "PASS_VALIDATION_EVENT_MISSING_PASSENGER_NAME"
            )
        }
    }

    @PassValidationBuilder
    func validateFlightPlan(_ semantics: Pass.Semantics?) -> [PassValidationIssue] {
        if #propertyEmpty(semantics?.airlineCode) {
            PassValidationIssue(
                severity: .error,
                domain: .flightPlan,
                property: #passProperty(semantics?.airlineCode),
                message: "PASS_VALIDATION_EVENT_MISSING_AIRLINE_CODE"
            )
        }

        if #propertyEmpty(semantics?.flightNumber) {
            PassValidationIssue(
                severity: .error,
                domain: .flightPlan,
                property: #passProperty(semantics?.flightNumber),
                message: "PASS_VALIDATION_EVENT_MISSING_FLIGHT_NUMBER"
            )
        }

        if #propertyEmpty(semantics?.originalDepartureDate) {
            PassValidationIssue(
                severity: .error,
                domain: .flightPlan,
                property: #passProperty(semantics?.originalDepartureDate),
                message: "PASS_VALIDATION_EVENT_MISSING_DEPARTURE_DATE"
            )
        }

        if #propertyEmpty(semantics?.originalBoardingDate) {
            PassValidationIssue(
                severity: .error,
                domain: .flightPlan,
                property: #passProperty(semantics?.originalBoardingDate),
                message: "PASS_VALIDATION_EVENT_MISSING_BOARDING_DATE"
            )
        }

        if #propertyEmpty(semantics?.originalArrivalDate) {
            PassValidationIssue(
                severity: .error,
                domain: .flightPlan,
                property: #passProperty(semantics?.originalArrivalDate),
                message: "PASS_VALIDATION_EVENT_MISSING_ARRIVAL_DATE"
            )
        }
    }

    @PassValidationBuilder
    func validateDepartureAirport(_ semantics: Pass.Semantics?) -> [PassValidationIssue] {
        if #propertyEmpty(semantics?.departureAirportTimeZone) {
            PassValidationIssue(
                severity: .error,
                domain: .airports,
                property: #passProperty(semantics?.departureAirportTimeZone),
                message: "PASS_VALIDATION_EVENT_MISSING_DEPARTURE_AIRPORT_TIMEZONE"
            )
        }

        if #propertyEmpty(semantics?.departureAirportCode) {
            PassValidationIssue(
                severity: .error,
                domain: .airports,
                property: #passProperty(semantics?.departureAirportCode),
                message: "PASS_VALIDATION_EVENT_MISSING_DEPARTURE_AIRPORT_CODE"
            )
        }

        if #propertyEmpty(semantics?.departureCityName) {
            PassValidationIssue(
                severity: .warning,
                domain: .airports,
                property: #passProperty(semantics?.departureCityName),
                message: "PASS_VALIDATION_EVENT_MISSING_DEPARTURE_CITY_NAME"
            )
        }
    }

    @PassValidationBuilder
    func validateArrivalAirport(_ semantics: Pass.Semantics?) -> [PassValidationIssue] {
        if #propertyEmpty(semantics?.destinationAirportTimeZone) {
            PassValidationIssue(
                severity: .warning,
                domain: .airports,
                property: #passProperty(semantics?.destinationAirportTimeZone),
                message: "PASS_VALIDATION_EVENT_MISSING_DESTINATION_AIRPORT_TIMEZONE"
            )
        }

        if #propertyEmpty(semantics?.destinationAirportCode) {
            PassValidationIssue(
                severity: .error,
                domain: .airports,
                property: #passProperty(semantics?.destinationAirportCode),
                message: "PASS_VALIDATION_EVENT_MISSING_DESTINATION_AIRPORT_CODE"
            )
        }

        if #propertyEmpty(semantics?.destinationCityName) {
            PassValidationIssue(
                severity: .warning,
                domain: .airports,
                property: #passProperty(semantics?.destinationCityName),
                message: "PASS_VALIDATION_EVENT_MISSING_DESTINATION_CITY_NAME"
            )
        }
    }
}
