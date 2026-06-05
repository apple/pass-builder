//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A category of pass properties used to scope validation diagnostics and editor context.
public enum PassPropertyDomain: Sendable, Hashable {
    /// The pass identity and signing configuration.
    case identitySigning
    /// The visual style and appearance settings.
    case style
    /// The barcode and NFC configuration.
    case barcodeNFC
    /// The pass image assets.
    case images

    // MARK: - Semantics
    /// The general semantic tag properties.
    case semantics
    /// The collection of seat assignments.
    case seats
    /// An individual seat being edited.
    case editSeat
    /// The associated links and URLs.
    case links

    // MARK: - Semantic Boarding Passes
    /// The flight plan details for a boarding pass.
    case flightPlan
    /// The passenger identification details for a boarding pass.
    case passengerDetails
    /// The departure and arrival airport details for a boarding pass.
    case airports
    /// The security screening details for a boarding pass.
    case security

    // MARK: - Semantic Event Tickets
    /// The general event details for an event ticket.
    case eventDetails
    /// The live performance details for an event ticket.
    case eventLivePerformance
    /// The sporting event details for an event ticket.
    case eventSport

    // MARK: - Fields
    /// The collection of all pass fields.
    case fields(style: PassStyle)
    /// The header field group.
    case headerFields(style: PassStyle)
    /// The primary field group.
    case primaryFields(style: PassStyle)
    /// The secondary field group.
    case secondaryFields(style: PassStyle)
    /// The auxiliary field group.
    case auxiliaryFields(style: PassStyle)
    /// The footer field group.
    case footerFields(style: PassStyle)
    /// The back-of-pass field group.
    case backFields(style: PassStyle)
    /// An individual field being edited.
    case editField(style: PassStyle)
}
