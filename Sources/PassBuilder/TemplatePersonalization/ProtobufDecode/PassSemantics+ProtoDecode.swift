//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.Semantics {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    init(protobuf: PBPassSemantics) throws {
        // Event-related properties
        seats = protobuf.seats.map { Pass.Seat(protobuf: $0) }

        if protobuf.hasAdmissionLevel {
            admissionLevel = protobuf.admissionLevel
        }
        if protobuf.hasAdmissionLevelAbbreviation {
            admissionLevelAbbreviation = protobuf.admissionLevelAbbreviation
        }
        if protobuf.hasAdditionalTicketAttributes {
            additionalTicketAttributes = protobuf.additionalTicketAttributes
        }
        if protobuf.hasAttendeeName {
            attendeeName = protobuf.attendeeName
        }
        if protobuf.hasEntranceDescription {
            entranceDescription = protobuf.entranceDescription
        }
        if protobuf.hasEventType {
            eventType = try EventType(protobuf: protobuf.eventType)
        }
        if protobuf.hasEventName {
            eventName = protobuf.eventName
        }
        if protobuf.hasEventStartDate {
            eventStartDate = Date(timeIntervalSince1970: protobuf.eventStartDate.timeIntervalSince1970)
        }
        if protobuf.hasEventStartDateInfo {
            eventStartDateInfo = EventDateInfo(protobuf: protobuf.eventStartDateInfo)
        }
        if protobuf.hasEventEndDate {
            eventEndDate = Date(timeIntervalSince1970: protobuf.eventEndDate.timeIntervalSince1970)
        }
        if protobuf.hasTailgatingAllowed {
            tailgatingAllowed = protobuf.tailgatingAllowed
        }

        // Venue-related properties
        if protobuf.hasVenueBoxOfficeOpenDate {
            venueBoxOfficeOpenDate = Date(timeIntervalSince1970: protobuf.venueBoxOfficeOpenDate.timeIntervalSince1970)
        }
        if protobuf.hasVenueCloseDate {
            venueCloseDate = Date(timeIntervalSince1970: protobuf.venueCloseDate.timeIntervalSince1970)
        }
        if protobuf.hasVenueDoorsOpenDate {
            venueDoorsOpenDate = Date(timeIntervalSince1970: protobuf.venueDoorsOpenDate.timeIntervalSince1970)
        }
        if protobuf.hasVenueEntrance {
            venueEntrance = protobuf.venueEntrance
        }
        if protobuf.hasVenueEntranceDoor {
            venueEntranceDoor = protobuf.venueEntranceDoor
        }
        if protobuf.hasVenueEntranceGate {
            venueEntranceGate = protobuf.venueEntranceGate
        }
        if protobuf.hasVenueEntrancePortal {
            venueEntrancePortal = protobuf.venueEntrancePortal
        }
        if protobuf.hasVenueFanZoneOpenDate {
            venueFanZoneOpenDate = Date(timeIntervalSince1970: protobuf.venueFanZoneOpenDate.timeIntervalSince1970)
        }
        if protobuf.hasVenueGatesOpenDate {
            venueGatesOpenDate = Date(timeIntervalSince1970: protobuf.venueGatesOpenDate.timeIntervalSince1970)
        }
        if protobuf.hasVenueLocation {
            venueLocation = Pass.Location(protobuf: protobuf.venueLocation)
        }
        if protobuf.hasVenueName {
            venueName = protobuf.venueName
        }
        if protobuf.hasVenueOpenDate {
            venueOpenDate = Date(timeIntervalSince1970: protobuf.venueOpenDate.timeIntervalSince1970)
        }
        if protobuf.hasVenueParkingLotsOpenDate {
            venueParkingLotsOpenDate = Date(
                timeIntervalSince1970: protobuf.venueParkingLotsOpenDate.timeIntervalSince1970
            )
        }
        if protobuf.hasVenuePhoneNumber {
            venuePhoneNumber = protobuf.venuePhoneNumber
        }
        if protobuf.hasVenueRegionName {
            venueRegionName = protobuf.venueRegionName
        }
        if protobuf.hasVenueRoom {
            venueRoom = protobuf.venueRoom
        }

        // Team-related properties (sports)
        if protobuf.hasAwayTeamAbbreviation {
            awayTeamAbbreviation = protobuf.awayTeamAbbreviation
        }
        if protobuf.hasAwayTeamLocation {
            awayTeamLocation = protobuf.awayTeamLocation
        }
        if protobuf.hasAwayTeamName {
            awayTeamName = protobuf.awayTeamName
        }
        if protobuf.hasHomeTeamAbbreviation {
            homeTeamAbbreviation = protobuf.homeTeamAbbreviation
        }
        if protobuf.hasHomeTeamLocation {
            homeTeamLocation = protobuf.homeTeamLocation
        }
        if protobuf.hasHomeTeamName {
            homeTeamName = protobuf.homeTeamName
        }
        if protobuf.hasLeagueAbbreviation {
            leagueAbbreviation = protobuf.leagueAbbreviation
        }
        if protobuf.hasLeagueName {
            leagueName = protobuf.leagueName
        }
        if protobuf.hasSportName {
            sportName = protobuf.sportName
        }

        // Performance-related properties
        if protobuf.hasGenre {
            genre = protobuf.genre
        }
        albumIDs = protobuf.albumIds
        artistIDs = protobuf.artistIds
        performerNames = protobuf.performerNames
        playlistIDs = protobuf.playlistIds

        // Flight-related properties
        passengerCapabilities = protobuf.airlinePassengerCapabilities
        if protobuf.hasAirlineCode {
            airlineCode = protobuf.airlineCode
        }
        if protobuf.hasAirlineLoungePlaceID {
            airlineLoungePlaceID = protobuf.airlineLoungePlaceID
        }
        if protobuf.hasBoardingGroup {
            boardingGroup = protobuf.boardingGroup
        }
        if protobuf.hasBoardingZone {
            boardingZone = protobuf.boardingZone
        }
        if protobuf.hasBoardingSequenceNumber {
            boardingSequenceNumber = protobuf.boardingSequenceNumber
        }
        if protobuf.hasCarNumber {
            carNumber = protobuf.carNumber
        }
        if protobuf.hasConfirmationNumber {
            confirmationNumber = protobuf.confirmationNumber
        }
        if protobuf.hasCurrentArrivalDate {
            currentArrivalDate = Date(timeIntervalSince1970: protobuf.currentArrivalDate.timeIntervalSince1970)
        }
        if protobuf.hasCurrentBoardingDate {
            currentBoardingDate = Date(timeIntervalSince1970: protobuf.currentBoardingDate.timeIntervalSince1970)
        }
        if protobuf.hasCurrentDepartureDate {
            currentDepartureDate = Date(timeIntervalSince1970: protobuf.currentDepartureDate.timeIntervalSince1970)
        }

        // Departure-related properties
        departureAirportSecurityPrograms = protobuf.departureAirportSecurityPrograms
        if protobuf.hasDepartureAirportCode {
            departureAirportCode = protobuf.departureAirportCode
        }
        if protobuf.hasDepartureAirportName {
            departureAirportName = protobuf.departureAirportName
        }
        if protobuf.hasDepartureAirportTimeZone {
            departureAirportTimeZone = protobuf.departureAirportTimeZone
        }
        if protobuf.hasDepartureCityName {
            departureCityName = protobuf.departureCityName
        }
        if protobuf.hasDepartureGate {
            departureGate = protobuf.departureGate
        }
        if protobuf.hasDepartureLocation {
            departureLocation = Pass.Location(protobuf: protobuf.departureLocation)
        }
        if protobuf.hasDepartureLocationDescription {
            departureLocationDescription = protobuf.departureLocationDescription
        }
        if protobuf.hasDeparturePlatform {
            departurePlatform = protobuf.departurePlatform
        }
        if protobuf.hasDepartureStationName {
            departureStationName = protobuf.departureStationName
        }
        if protobuf.hasDepartureTerminal {
            departureTerminal = protobuf.departureTerminal
        }

        // Destination-related properties
        destinationAirportSecurityPrograms = protobuf.destinationAirportSecurityPrograms
        if protobuf.hasDestinationAirportCode {
            destinationAirportCode = protobuf.destinationAirportCode
        }
        if protobuf.hasDestinationAirportName {
            destinationAirportName = protobuf.destinationAirportName
        }
        if protobuf.hasDestinationAirportTimeZone {
            destinationAirportTimeZone = protobuf.destinationAirportTimeZone
        }
        if protobuf.hasDestinationCityName {
            destinationCityName = protobuf.destinationCityName
        }
        if protobuf.hasDestinationGate {
            destinationGate = protobuf.destinationGate
        }
        if protobuf.hasDestinationLocation {
            destinationLocation = Pass.Location(protobuf: protobuf.destinationLocation)
        }
        if protobuf.hasDestinationLocationDescription {
            destinationLocationDescription = protobuf.destinationLocationDescription
        }
        if protobuf.hasDestinationPlatform {
            destinationPlatform = protobuf.destinationPlatform
        }
        if protobuf.hasDestinationStationName {
            destinationStationName = protobuf.destinationStationName
        }
        if protobuf.hasDestinationTerminal {
            destinationTerminal = protobuf.destinationTerminal
        }

        // Flight details
        if protobuf.hasDuration {
            duration = Int(protobuf.duration)
        }
        if protobuf.hasFlightCode {
            flightCode = protobuf.flightCode
        }
        if protobuf.hasFlightNumber {
            flightNumber = Int(protobuf.flightNumber)
        }
        if protobuf.hasInternationalDocumentsAreVerified {
            internationalDocumentsAreVerified = protobuf.internationalDocumentsAreVerified
        }
        if protobuf.hasInternationalDocumentsVerifiedDeclarationName {
            internationalDocumentsVerifiedDeclarationName = protobuf.internationalDocumentsVerifiedDeclarationName
        }

        // Membership and passenger details
        if protobuf.hasMembershipProgramName {
            membershipProgramName = protobuf.membershipProgramName
        }
        if protobuf.hasMembershipProgramNumber {
            membershipProgramNumber = protobuf.membershipProgramNumber
        }
        if protobuf.hasOriginalBoardingDate {
            originalBoardingDate = Date(timeIntervalSince1970: protobuf.originalBoardingDate.timeIntervalSince1970)
        }
        if protobuf.hasOriginalDepartureDate {
            originalDepartureDate = Date(timeIntervalSince1970: protobuf.originalDepartureDate.timeIntervalSince1970)
        }
        if protobuf.hasOriginalArrivalDate {
            originalArrivalDate = Date(timeIntervalSince1970: protobuf.originalArrivalDate.timeIntervalSince1970)
        }

        passengerAirlineSSRs = protobuf.passengerAirlineSsrs
        passengerInformationSSRs = protobuf.passengerInformationSsrs
        passengerServiceSSRs = protobuf.passengerServiceSsrs
        passengerEligibleSecurityPrograms = protobuf.passengerEligibleSecurityPrograms

        if protobuf.hasPassengerName {
            passengerName = Pass.PersonName(protobuf: protobuf.passengerName)
        }
        if protobuf.hasPriorityStatus {
            priorityStatus = protobuf.priorityStatus
        }
        if protobuf.hasSecurityScreening {
            securityScreening = protobuf.securityScreening
        }

        // Ticket and transit details
        if protobuf.hasTicketFareClass {
            ticketFareClass = protobuf.ticketFareClass
        }
        if protobuf.hasTransitProvider {
            transitProvider = protobuf.transitProvider
        }
        if protobuf.hasTransitStatus {
            transitStatus = protobuf.transitStatus
        }
        if protobuf.hasTransitStatusReason {
            transitStatusReason = protobuf.transitStatusReason
        }
        if protobuf.hasVehicleName {
            vehicleName = protobuf.vehicleName
        }
        if protobuf.hasVehicleNumber {
            vehicleNumber = protobuf.vehicleNumber
        }
        if protobuf.hasVehicleType {
            vehicleType = protobuf.vehicleType
        }

        // Financial properties
        if protobuf.hasBalance {
            balance = CurrencyAmount(protobuf: protobuf.balance)
        }
        if protobuf.hasSilenceRequested {
            silenceRequested = protobuf.silenceRequested
        }
        if protobuf.hasTotalPrice {
            totalPrice = CurrencyAmount(protobuf: protobuf.totalPrice)
        }

        wifiAccess = protobuf.wifiAccess.map { Pass.Semantics.WifiNetwork(protobuf: $0) }
    }
}

extension Pass.Semantics.CurrencyAmount {
    init(protobuf: PBPassSemantics.CurrencyAmount) {
        amount = protobuf.amount
        currencyCode = protobuf.currencyCode
    }
}

extension Pass.Semantics.EventDateInfo {
    init(protobuf: PBPassSemantics.EventDateInfo) {
        date = protobuf.date
        ignoreTimeComponents = protobuf.ignoreTimeComponents
        timeZone = protobuf.timeZone
        unannounced = protobuf.unannounced
        undetermined = protobuf.undetermined
    }
}

extension Pass.Semantics.EventType {
    init(protobuf: PBPassSemantics.EventType) throws {
        switch protobuf {
        case .generic: self = .generic
        case .livePerformance: self = .livePerformance
        case .movie: self = .movie
        case .sports: self = .sports
        case .conference: self = .conference
        case .convention: self = .convention
        case .workshop: self = .workshop
        case .socialGathering: self = .socialGathering
        default: throw ProtobufError.invalidValue(message: "Pass.Semantics.EventType type is not recognized.")
        }
    }
}

extension Pass.Semantics.WifiNetwork {
    init(protobuf: PBPassSemantics.WifiNetwork) {
        ssid = protobuf.ssid
        password = protobuf.password
    }
}
