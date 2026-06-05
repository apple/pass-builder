//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass.UpcomingPassInformationEntry {
    /// An object with links to information about the upcoming pass information entry.
    struct URLs: Codable, Equatable, Sendable {
        /// A URL that links to your or the venue’s accessibility content.
        public var accessibilityURL: String?

        /// A URL that links to add-on experiences for the ticket, including any QR or barcode links needed to access
        /// pre-purchased or preloaded items. For example, loaded value or upgrades for an experience.
        public var addOnURL: String?

        /// A URL that links out to the bag policy of the venue.
        public var bagPolicyURL: String?

        /// The preferred email address to contact the venue, event, or issuer.
        public var contactVenueEmail: String?

        /// The preferred phone number to contact the venue, event, or issuer.
        public var contactVenuePhoneNumber: String?

        /// A URL that links the user to the website of the venue, event, or issuer.
        public var contactVenueWebsite: String?

        /// A URL that links to content you have about getting to the venue.
        public var directionsInformationURL: String?

        /// A URL that links to order merchandise for the specific event. This can be a ship-to-home ecommerce
        /// site, a pre-order to pick up at the venue, or other appropriate merchandise flow. You can update this
        /// link throughout the user’s journey to provide more accurately tailored links at certain times — for
        /// example, before versus after a user enters an event. Update the link through a pass update.
        public var merchandiseURL: String?

        /// A URL that links out to the food-ordering page for the venue. This can be in-seat food delivery,
        /// pre-order for pickup at a vendor, or other appropriate food-ordering service.
        public var orderFoodURL: String?

        /// A URL that links to any information you have about parking.
        public var parkingInformationURL: String?

        /// A URL that links to your experience to buy or access prepaid parking or general parking information.
        public var purchaseParkingURL: String?

        /// A URL that launches the user into the issuer’s flow for selling their current ticket. Provide as
        /// deep a link as possible into the sale flow.
        public var sellURL: String?

        /// A URL that launches the user into the issuer’s flow for transferring the current ticket. Provide as
        /// deep a link as possible into the transfer flow.
        public var transferURL: String?

        /// A URL that links to documentation you have about public or private transit to the venue.
        public var transitInformationURL: String?
    }
}
