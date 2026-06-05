//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation
@_exported import PassMacros

/// An object that represents a pass.
public struct Pass: Equatable, Codable, Sendable {

    // MARK: - Fields

    public var boardingPass: Pass.Fields?

    public var eventTicket: Pass.Fields?

    public var coupon: Pass.Fields?

    public var storeCard: Pass.Fields?

    public var generic: Pass.Fields?

    public var posterGeneric: Pass.Fields?

    // MARK: - Standard Top-Level Keys.

    /// (Required) The version of the file format. The value must be `1`.
    var formatVersion: Int = 1

    /// (Required) An alphanumeric serial number. The combination of the serial number and pass type identifier
    /// must be unique for each pass.
    public var serialNumber: String = ""

    /// The URL for a web service that you use to update or personalize the pass. The URL can include an optional
    /// port number.
    public var webServiceURL: String?

    /// The authentication token to use with the web service in the `webServiceURL` key.
    public var authenticationToken: String?

    /// (Required) The pass type identifier that’s registered with Apple. The value must match the
    /// distribution certificate that signs the pass.
    public var passTypeIdentifier: String = "pass."

    /// (Required) The Team ID for the Apple Developer Program account that registered the pass type identifier.
    public var teamIdentifier: String = ""

    /// (Required) The name of the organization.
    public var organizationName: String = ""

    /// (Required) A short description that iOS accessibility technologies use for a pass.
    public var description: String = ""

    /// A Boolean value that controls whether to show the Share button on the back of a pass.
    /// A value of `true` removes the button. The default value is `false`. This flag has no effect in iOS 10 or
    /// earlier, nor does it prevent sharing the pass in some other way.
    public var sharingProhibited: Bool?

    // MARK: - Associated App Keys

    /// An array of App Store identifiers for apps associated with the pass. The associated app on a device is the
    /// first item in the array that’s compatible with that device. A link to launch the app is on the back of the
    /// pass. If the app isn’t installed, the link opens the App Store.
    public var associatedStoreIdentifiers: [Int]?

    /// An array of additional App Store identifiers for apps associated with the pass. The associated app on a device
    /// is the first item in the array that’s compatible with that device. This key works only for poster event tickets.
    /// A link to launch the app is in the event guide of the pass. If the app isn’t installed, the link opens the
    /// App Store.
    public var auxiliaryStoreIdentifiers: [Int]?

    // MARK: - Expiry Keys

    /// The date and time the pass expires.
    public var expirationDate: Date?

    /// A Boolean value that indicates that the pass is void, such as a redeemed, one-time-use coupon.
    /// The default value is false.
    public var voided: Bool?

    // MARK: - Barcodes

    /// An object that represents a barcode on a pass.
    /// This object is deprecated. Use `barcodes` instead.
    public var barcode: Pass.Barcode?

    /// An array of objects that represent possible barcodes on a pass. The system uses the first displayable barcode
    /// for the device.
    public var barcodes: [Pass.Barcode]?

    // MARK: - Relevance Keys

    /// The maximum distance, in meters, from a location in the `locations` array at which the pass is relevant.
    /// The system uses the smaller of this distance or the default distance.
    public var maxDistance: Distance?

    /// The date and time when the pass becomes relevant, as a W3C timestamp, such as the start time of a movie.
    /// The value must be a complete date that includes hours and minutes, and may optionally include seconds.
    public var relevantDate: Date?

    /// An array of objects that represent date intervals that the system uses to show a relevant pass.
    public var relevantDates: [RelevantDate]?

    /// An array of up to 10 objects that represent geographic locations the system uses to show a relevant pass.
    public var locations: [Location]?

    /// An array of objects that represent the identity of Bluetooth Low Energy beacons the system uses to show a
    /// relevant pass.
    public var beacons: [Beacon]?

    // MARK: - Visual Appearance Keys

    /// A background color for the pass.
    public var backgroundColor: Pass.Color?

    /// A foreground color for the pass.
    public var foregroundColor: Pass.Color?

    /// A color for the label text of the pass. If you don’t provide a value, the system determines the label color.
    public var labelColor: Pass.Color?

    /// A strip color for the pass.
    public var stripColor: Pass.Color?

    /// A background color for the footer of the pass.
    /// This key works only for poster event tickets.
    public var footerBackgroundColor: Pass.Color?

    /// A Boolean value that controls whether to display the header darkening gradient on poster event tickets.
    /// The default value is false.
    /// This key works only for poster event tickets.
    public var suppressHeaderDarkening: Bool?

    /// A Boolean value that controls whether Wallet computes the foreground and label color that the pass uses.
    /// The system derives the background color from the background image of the pass.
    /// This key works only for poster event tickets.
    /// This key ignores the values that `foregroundColor` and `labelColor` specify.
    public var useAutomaticColors: Bool?

    /// The text to display next to the logo on the pass.
    /// This key works only for poster event tickets.
    public var eventLogoText: String?

    /// The text to display next to the logo on the pass.
    /// This key doesn’t work for poster event tickets.
    public var logoText: String?

    /// An SF Symbol to display as a logo image.
    public var logoSymbolName: String?

    /// An identifier the system uses to group related boarding passes or event tickets.
    /// Wallet displays passes with the same `groupingIdentifier`, `passTypeIdentifier`, and type as a group.
    /// Use this identifier to group passes that are tightly related, such as boarding passes for different
    /// connections on the same trip.
    public var groupingIdentifier: String?

    /// An array of featured pass actions.
    public var featuredActions: [Pass.Action]?

    // MARK: - NFC

    /// An object that contains information for Value-Added Services protocol transactions.
    public var nfc: Pass.NFC?

    // MARK: - Semantics

    /// An array of schemes to validate the pass with. The system validates the pass and its contents to ensure they
    /// meet the schemes’ requirements. If validation fails for all the provided schemes, the system falls back to
    /// the originally designated style.
    public var preferredStyleSchemes: [String]?

    /// An object that contains machine-readable metadata the system uses to offer a pass and suggest related actions.
    public var semantics: Pass.Semantics?

    // MARK: - Links

    /// A URL that links to your accessibility content, or the venue’s.
    /// This key works only for poster event tickets.
    public var accessibilityURL: String?

    /// A URL that can link to experiences that someone can add to the pass.
    /// This key works only for poster event tickets.
    public var addOnURL: String?

    /// A URL the system passes to the associated app from `associatedStoreIdentifiers` during launch.
    public var appLaunchURL: String?

    /// A URL that links to the bag policy of the venue for the event that the pass represents.
    /// This key works only for poster event tickets.
    public var bagPolicyURL: String?

    /// A URL that links to a site for ordering merchandise for the event that the pass represents.
    /// This key works only for poster event tickets.
    public var merchandiseURL: String?

    /// A URL that links to the food ordering page for the event that the pass represents.
    /// This key works only for poster event tickets.
    public var orderFoodURL: String?

    /// A URL that links to parking information for the event that the pass represents.
    /// This key works only for poster event tickets.
    public var parkingInformationURL: String?

    /// A URL that links to a site to purchase parking for the event that the pass represents.
    /// This key works only for poster event tickets.
    public var purchaseParkingURL: String?

    /// A URL that links to the selling flow for the ticket the pass represents.
    /// This key works only for poster event tickets.
    public var sellURL: String?

    /// A URL that links to the transferring flow for the ticket that the pass represents.
    /// This key works only for poster event tickets.
    public var transferURL: String?

    /// A URL that links to information about transit options in the area of the event that the pass represents.
    /// This key works only for poster event tickets.
    public var transitInformationURL: String?

    /// The preferred email address to contact the venue, event, or issuer.
    /// This key works only for poster event tickets.
    public var contactVenueEmail: String?

    /// The phone number for contacting the venue, event, or issuer.
    /// This key works only for poster event tickets.
    public var contactVenuePhoneNumber: String?

    /// A URL that links to the website of the venue, event, or issuer.
    /// This key works only for poster event tickets.
    public var contactVenueWebsite: String?

    /// A URL that links to directions for the event.
    /// This key works only for poster event tickets.
    public var directionsInformationURL: String?

    /// An ordered list of all upcoming pass information entries.
    public var upcomingPassInformation: [UpcomingPassInformationEntry]?

    /// A URL for changing the seat for the ticket.
    public var changeSeatURL: String?

    /// A URL for in-flight entertainment.
    public var entertainmentURL: String?

    /// A URL for adding checked bags for the ticket.
    public var purchaseAdditionalBaggageURL: String?

    /// A URL that links to information to purchase lounge access.
    public var purchaseLoungeAccessURL: String?

    /// A URL for purchasing in-flight Wi-Fi.
    public var purchaseWifiURL: String?

    /// A URL for upgrading the flight.
    public var upgradeURL: String?

    /// A URL for management.
    public var managementURL: String?

    /// A URL for registering a service animal.
    public var registerServiceAnimalURL: String?

    /// A URL to report a lost bag.
    public var reportLostBagURL: String?

    /// A URL to request a wheelchair.
    public var requestWheelchairURL: String?

    /// The email for the transit provider.
    public var transitProviderEmail: String?

    /// The phone number for the transit provider.
    public var transitProviderPhoneNumber: String?

    /// The URL for the transit provider.
    public var transitProviderWebsiteURL: String?

    public init() {}
}
