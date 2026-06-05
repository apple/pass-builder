//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass {
    /// An object that contains machine-readable metadata the system uses to offer a pass and suggest related actions.
    struct Semantics: Equatable, Codable, Sendable {
        // MARK: - Events

        /// The level of admission the ticket provides, such as general admission, VIP, and so forth.
        /// Use this key for any type of event ticket.
        public var admissionLevel: String?

        /// An abbreviation of the level of admission the ticket provides, such as GA or VIP.
        /// Use this key for any type of event ticket.
        public var admissionLevelAbbreviation: String?

        /// Additional ticket attributes that other tags or keys in the pass don’t include.
        /// Use this key for any type of event ticket.
        public var additionalTicketAttributes: String?

        /// The name of the person the ticket grants admission to.
        /// Use this key for any type of event ticket.
        public var attendeeName: String?

        /// The long description of the entrance information. Use this key for any type of event ticket.
        public var entranceDescription: String?

        /// The type of event. Use this key for any type of event ticket.
        public var eventType: EventType? = .generic

        /// The full name of the event, such as the title of a movie. Use this key for any type of event ticket.
        public var eventName: String?

        /// The date and time the event starts. Use this key for any type of event ticket.
        public var eventStartDate: Date?

        /// An object that provides information for the date and time the event starts.
        /// Use this key for any type of event ticket.
        public var eventStartDateInfo: EventDateInfo?

        /// The date and time the event ends. Use this key for any type of event ticket.
        public var eventEndDate: Date?

        /// An array of objects that represent the details for each seat at an event or on a transit journey.
        /// Use this key for any type of boarding pass or event ticket.
        public var seats: [Pass.Seat]?

        /// A Boolean value that indicates whether tailgating is allowed at the event.
        /// Use this key for any type of event ticket.
        public var tailgatingAllowed: Bool?

        /// The date when the box office opens. Use this key for any type of event ticket.
        public var venueBoxOfficeOpenDate: Date?

        /// The date when the venue closes. Use this key for any type of event ticket.
        public var venueCloseDate: Date?

        /// The date the doors to the venue open. Use this key for any type of event ticket.
        public var venueDoorsOpenDate: Date?

        /// The full name of the entrance, such as Gate A, to use to gain access to the ticketed event.
        /// Use this key for any type of event ticket.
        public var venueEntrance: String?

        /// The venue entrance door. Use this key for any type of event ticket.
        public var venueEntranceDoor: String?

        /// The venue entrance gate. Use this key for any type of event ticket.
        public var venueEntranceGate: String?

        /// The venue entrance portal. Use this key for any type of event ticket.
        public var venueEntrancePortal: String?

        /// The date the fan zone opens. Use this key for any type of event ticket.
        public var venueFanZoneOpenDate: Date?

        /// The date the gates to the venue open. Use this key for any type of event ticket.
        public var venueGatesOpenDate: Date?

        /// An object that represents the geographic coordinates of the venue.
        /// Use this key for any type of event ticket.
        public var venueLocation: Pass.Location?

        /// The full name of the venue. Use this key for any type of event ticket.
        public var venueName: String?

        /// The date when the venue opens. Use this if none of the more specific venue open tags apply.
        /// Use this key for any type of event ticket.
        public var venueOpenDate: Date?

        /// The date the parking lots open. Use this key for any type of event ticket.
        public var venueParkingLotsOpenDate: Date?

        /// The phone number for inquiries about the venue’s ticketed event. Use this key for any type of event ticket.
        public var venuePhoneNumber: String?

        /// The name of the city or hosting region of the venue. Use this key for any type of event ticket.
        public var venueRegionName: String?

        /// The full name of the room where the ticketed event is to take place.
        /// Use this key for any type of event ticket.
        public var venueRoom: String?

        // MARK: - Sports

        /// The unique abbreviation of the away team’s name.
        /// Use this key only for a sports event ticket.
        public var awayTeamAbbreviation: String?

        /// The home location of the away team. Use this key only for a sports event ticket.
        public var awayTeamLocation: String?

        /// The name of the away team. Use this key only for a sports event ticket.
        public var awayTeamName: String?

        /// The unique abbreviation of the home team’s name. Use this key only for a sports event ticket.
        public var homeTeamAbbreviation: String?

        /// The home location of the home team. Use this key only for a sports event ticket.
        public var homeTeamLocation: String?

        /// The name of the home team. Use this key only for a sports event ticket.
        public var homeTeamName: String?

        /// The abbreviated league name for a sports event. Use this key only for a sports event ticket.
        public var leagueAbbreviation: String?

        /// The unabbreviated league name for a sports event. Use this key only for a sports event ticket.
        public var leagueName: String?

        /// The commonly used name of the sport. Use this key only for a sports event ticket.
        public var sportName: String?

        // MARK: - Live Performances

        /// The genre of the performance, such as classical. Use this key for any type of event ticket.
        public var genre: String?

        /// An array of the Apple Music persistent ID for each album corresponding to the event,
        /// in decreasing order of significance.
        /// Use this key for any type of event ticket.
        public var albumIDs: [String]?

        /// An array of the Apple Music persistent ID for each artist performing at the event,
        /// in decreasing order of significance.
        /// Use this key for any type of event ticket.
        public var artistIDs: [String]?

        /// An array of the full names of the performers and opening acts at the event,
        /// in decreasing order of significance.
        /// Use this key for any type of event ticket.
        public var performerNames: [String]?

        /// An array of the Apple Music persistent ID for each playlist corresponding to the event,
        /// in decreasing order of significance.
        /// Use this key for any type of event ticket.
        public var playlistIDs: [String]?

        // MARK: - Boarding Passes

        /// The IATA airline code, such as EX for flightCode EX123. Use this key only for airline boarding passes.
        public var airlineCode: String?

        /// A MapKit Place ID that references the airline lounge location.
        public var airlineLoungePlaceID: String?

        /// A list of airline-specific capabilities the passenger has. Only use this key for airline boarding passes.
        public var passengerCapabilities: [String]?

        /// A group number for boarding. Use this key for any type of boarding pass.
        public var boardingGroup: String?

        /// A zone number for boarding. Don’t include the word `zone`.
        public var boardingZone: String?

        /// A sequence number for boarding. Use this key for any type of boarding pass.
        public var boardingSequenceNumber: String?

        /// The number of the passenger car. A train car is also called a carriage, wagon, coach, or bogie in some
        /// countries. Use this key only for a train or other rail boarding pass.
        public var carNumber: String?

        /// A booking or reservation confirmation number. Use this key for any type of boarding pass.
        public var confirmationNumber: String?

        /// The updated date and time of arrival, if different from the originally scheduled date and time.
        /// Use this key for any type of boarding pass.
        public var currentArrivalDate: Date?

        /// The updated date and time of boarding, if different from the originally scheduled date and time.
        /// Use this key for any type of boarding pass.
        public var currentBoardingDate: Date?

        /// The updated departure date and time, if different from the originally scheduled date and time.
        /// Use this key for any type of boarding pass.
        public var currentDepartureDate: Date?

        /// The IATA airport code for the departure airport, such as MPM or LHR.
        /// Use this key only for airline boarding passes.
        public var departureAirportCode: String?

        /// The full name of the departure airport, such as Maputo International Airport.
        /// Use this key only for airline boarding passes.
        public var departureAirportName: String?

        /// A list of security programs that exist in the departure airport. This only shows in the UI if a program
        /// is in `passengerEligibleSecurityPrograms` and at least one of `departureAirportSecurityPrograms` or
        /// `destinationAirportSecurityPrograms`.
        public var departureAirportSecurityPrograms: [String]?

        /// The time zone for the departure airport, such as America/Los_Angeles.
        public var departureAirportTimeZone: String?

        /// The name of the departure city to display on the boarding pass, such as London or Shanghai.
        public var departureCityName: String?

        /// The gate number or letters of the departure gate, such as 1A. Don’t include the word `gate`.
        public var departureGate: String?

        /// An object that represents the geographic coordinates of the transit departure location, suitable for
        /// display on a map. If possible, use precise locations, which are more useful to travelers; for example,
        /// the specific location of an airport gate. Use this key for any type of boarding pass.
        public var departureLocation: Pass.Location?

        /// A brief description of the departure location. For example, for a flight departing from an airport
        /// that has a code of LHR, an appropriate description might be London, Heathrow.
        /// Use this key for any type of boarding pass.
        public var departureLocationDescription: String?

        /// The name of the departure platform, such as A. Don’t include the word `platform`.
        /// Use this key only for a train or other rail boarding pass.
        public var departurePlatform: String?

        /// The name of the departure station, such as 1st Street Station.
        /// Use this key only for a train or other rail boarding pass.
        public var departureStationName: String?

        /// The name or letter of the departure terminal, such as A. Don’t include the word `terminal`.
        /// Use this key only for airline boarding passes.
        public var departureTerminal: String?

        /// The IATA airport code for the destination airport, such as MPM or LHR.
        /// Use this key only for airline boarding passes.
        public var destinationAirportCode: String?

        /// The full name of the destination airport, such as London Heathrow.
        /// Use this key only for airline boarding passes.
        public var destinationAirportName: String?

        /// A list of security programs that exist in the destination airport. This only shows in the UI if a program
        /// is in `passengerEligibleSecurityPrograms` and at least one of `departureAirportSecurityPrograms` or
        /// `destinationAirportSecurityPrograms`.
        public var destinationAirportSecurityPrograms: [String]?

        /// The time zone for the destination airport, such as America/Los_Angeles.
        public var destinationAirportTimeZone: String?

        /// The name of the destination city to display on the boarding pass, such as London or Shanghai.
        public var destinationCityName: String?

        /// The gate number or letter of the destination gate, such as 1A. Don’t include the word `gate`.
        /// Use this key only for airline boarding passes.
        public var destinationGate: String?

        /// An object that represents the geographic coordinates of the transit destination location, suitable for
        /// display on a map. Use this key for any type of boarding pass.
        public var destinationLocation: Pass.Location?

        /// A brief description of the destination location. For example, for a flight arriving at an airport that has
        /// a code of MPM, Maputo might be an appropriate description. Use this key for any type of boarding pass.
        public var destinationLocationDescription: String?

        /// The name of the destination platform, such as A. Don’t include the word `platform`.
        /// Use this key only for a train or other rail boarding pass.
        public var destinationPlatform: String?

        /// The name of the destination station, such as 1st Street Station.
        /// Use this key only for a train or other rail boarding pass.
        public var destinationStationName: String?

        /// The terminal name or letter of the destination terminal, such as A. Don’t include the word `terminal`.
        /// Use this key only for airline boarding passes.
        public var destinationTerminal: String?

        /// The duration of the event or transit journey, in seconds.
        /// Use this key for any type of boarding pass and any type of event ticket.
        public var duration: Int?

        /// The IATA flight code, such as EX123. Use this key only for airline boarding passes.
        public var flightCode: String?

        /// The numeric portion of the IATA flight code, such as 123 for flightCode EX123.
        /// Use this key only for airline boarding passes.
        public var flightNumber: Int?

        /// An optional boolean that indicates whether the passenger’s international documents are verified.
        /// If set to true Wallet displays the badge on the boarding pass with the value
        /// from `internationalDocumentsVerifiedDeclarationName`.
        public var internationalDocumentsAreVerified: Bool?

        /// The name of the declaration given once the passenger’s international documents are verified.
        /// Examples include DOCS OK or Travel Ready. If `internationalDocumentsAreVerified` is true, Wallet displays
        /// a badge on the boarding pass with this value.
        public var internationalDocumentsVerifiedDeclarationName: String?

        /// The name of a frequent flyer or loyalty program. Use this key for any type of boarding pass.
        public var membershipProgramName: String?

        /// The ticketed passenger’s frequent flyer or loyalty number. Use this key for any type of boarding pass.
        public var membershipProgramNumber: String?

        /// The originally scheduled date and time of arrival. Use this key for any type of boarding pass.
        public var originalBoardingDate: Date?

        /// The originally scheduled date and time of boarding. Use this key for any type of boarding pass.
        public var originalDepartureDate: Date?

        /// The originally scheduled date and time of departure. Use this key for any type of boarding pass.
        public var originalArrivalDate: Date?

        /// An array of airline-specific SSRs that apply to the ticketed passenger.
        public var passengerAirlineSSRs: [String]?

        /// An array of IATA information SSRs that apply to the ticketed passenger.
        public var passengerInformationSSRs: [String]?

        /// An object that represents the name of the passenger. Use this key for any type of boarding pass.
        public var passengerName: Pass.PersonName?

        /// An array of IATA SSRs that apply to the ticketed passenger.
        public var passengerServiceSSRs: [String]?

        /// A list of security programs the passenger supports. This only shows in the UI if a program
        /// is in `passengerEligibleSecurityPrograms` and at least one of `departureAirportSecurityPrograms` or
        /// `destinationAirportSecurityPrograms`.
        public var passengerEligibleSecurityPrograms: [String]?

        /// The priority status the ticketed passenger holds, such as Gold or Silver.
        /// Use this key for any type of boarding pass.
        public var priorityStatus: String?

        /// The type of security screening for the ticketed passenger, such as Priority.
        /// Use this key for any type of boarding pass.
        public var securityScreening: String?

        /// A localizable string that denotes the ticket class, such as Saver, Economy, First.
        /// This value displays as a badge on the boarding pass.
        public var ticketFareClass: String?

        /// The name of the transit company. Use this key for any type of boarding pass.
        public var transitProvider: String?

        /// A brief description of the current boarding status for the vessel, such as On Time or Delayed.
        /// For delayed status, provide `currentBoardingDate`, `currentDepartureDate`, and `currentArrivalDate` where
        /// available. Use this key for any type of boarding pass.
        public var transitStatus: String?

        /// A brief description that explains the reason for the current transitStatus, such as `Thunderstorms`.
        /// Use this key for any type of boarding pass.
        public var transitStatusReason: String?

        /// The name of the vehicle to board, such as the name of a boat. Use this key for any type of boarding pass.
        public var vehicleName: String?

        /// The identifier of the vehicle to board, such as the aircraft registration number or train number.
        /// Use this key for any type of boarding pass.
        public var vehicleNumber: String?

        /// A brief description of the type of vehicle to board, such as the model and manufacturer of a
        /// plane or the class of a boat. Use this key for any type of boarding pass.
        public var vehicleType: String?

        // MARK: - Store Cards

        /// The current balance redeemable with the pass. Use this key only for a store card pass.
        public var balance: CurrencyAmount?

        // MARK: - General

        /// A Boolean value that determines whether the person’s device remains silent during an event or transit journey.
        /// The system may override the key and determine the length of the period of silence.
        /// Use this key for any type of boarding pass or event ticket.
        public var silenceRequested: Bool?

        /// The total price for the pass. Use this key for any pass type.
        public var totalPrice: CurrencyAmount?

        /// An array of objects that represent the Wi-Fi networks associated with the event; for example,
        /// the network name and password associated with a developer conference. Use this key for any type of pass.
        public var wifiAccess: [WifiNetwork]?

        public init() {}
    }
}
