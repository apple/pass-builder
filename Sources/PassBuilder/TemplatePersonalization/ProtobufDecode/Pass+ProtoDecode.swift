//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    mutating func extractMessage(from protobuf: PBPass) throws {
        if protobuf.serialNumber.isEmpty {
            throw ProtobufError.invalidValue(message: "Pass.serialNumber is required.")
        } else {
            serialNumber = protobuf.serialNumber
        }

        if protobuf.hasWebServiceURL {
            webServiceURL = protobuf.webServiceURL
        }

        if protobuf.hasAuthenticationToken {
            authenticationToken = protobuf.authenticationToken
        }

        if protobuf.hasPassTypeIdentifier {
            passTypeIdentifier = protobuf.passTypeIdentifier
        }

        if protobuf.hasTeamIdentifier {
            teamIdentifier = protobuf.teamIdentifier
        }

        if protobuf.hasOrganizationName {
            organizationName = protobuf.organizationName
        }

        if protobuf.hasDescription_p {
            description = protobuf.description_p
        }

        if protobuf.hasSharingProhibited {
            sharingProhibited = protobuf.sharingProhibited
        }

        if protobuf.hasFields {
            try boardingPass?.extractMessage(from: protobuf.fields)
            try coupon?.extractMessage(from: protobuf.fields)
            try storeCard?.extractMessage(from: protobuf.fields)
            try posterGeneric?.extractMessage(from: protobuf.fields)
            try generic?.extractMessage(from: protobuf.fields)
            try eventTicket?.extractMessage(from: protobuf.fields)
        }

        if !protobuf.associatedStoreIdentifiers.isEmpty {
            associatedStoreIdentifiers = protobuf.associatedStoreIdentifiers.map { Int($0) }
        }

        if !protobuf.auxiliaryStoreIdentifiers.isEmpty {
            auxiliaryStoreIdentifiers = protobuf.auxiliaryStoreIdentifiers.map { Int($0) }
        }

        if protobuf.hasExpirationDate {
            expirationDate = Date(timeIntervalSince1970: protobuf.expirationDate.timeIntervalSince1970)
        }

        if protobuf.hasVoided {
            voided = protobuf.voided
        }

        if !protobuf.barcodes.isEmpty {
            barcodes = try protobuf.barcodes.map { try Pass.Barcode(protobuf: $0) }
            // Set the first barcode as the legacy single barcode
            barcode = barcodes?.first
        }

        if !protobuf.featuredActions.isEmpty {
            featuredActions = protobuf.featuredActions.map { Pass.Action(protobuf: $0) }
        }

        if protobuf.hasMaxDistance {
            maxDistance = Pass.Distance(meters: protobuf.maxDistance)
        }

        if protobuf.hasRelevantDate {
            relevantDate = Date(timeIntervalSince1970: protobuf.relevantDate.timeIntervalSince1970)
        }

        if !protobuf.relevantDates.isEmpty {
            relevantDates = protobuf.relevantDates.map { Pass.RelevantDate(protobuf: $0) }
        }

        if !protobuf.locations.isEmpty {
            locations = protobuf.locations.map { Pass.Location(protobuf: $0) }
        }

        if !protobuf.beacons.isEmpty {
            beacons = protobuf.beacons.map { Pass.Beacon(protobuf: $0) }
        }

        if protobuf.hasBackgroundColor {
            backgroundColor = Pass.Color(protobuf: protobuf.backgroundColor)
        }

        if protobuf.hasForegroundColor {
            foregroundColor = Pass.Color(protobuf: protobuf.foregroundColor)
        }

        if protobuf.hasLabelColor {
            labelColor = Pass.Color(protobuf: protobuf.labelColor)
        }

        if protobuf.hasStripColor {
            stripColor = Pass.Color(protobuf: protobuf.stripColor)
        }

        if protobuf.hasFooterBackgroundColor {
            footerBackgroundColor = Pass.Color(protobuf: protobuf.footerBackgroundColor)
        }

        if protobuf.hasSuppressHeaderDarkening {
            suppressHeaderDarkening = protobuf.suppressHeaderDarkening
        }

        if protobuf.hasUseAutomaticColors {
            useAutomaticColors = protobuf.useAutomaticColors
        }

        if protobuf.hasEventLogoText {
            eventLogoText = protobuf.eventLogoText
        }

        if protobuf.hasLogoText {
            logoText = protobuf.logoText
        }

        if protobuf.hasGroupingIdentifier {
            groupingIdentifier = protobuf.groupingIdentifier
        }

        if protobuf.hasNfc {
            nfc = Pass.NFC(protobuf: protobuf.nfc)
        }

        if !protobuf.preferredStyleSchemes.isEmpty {
            preferredStyleSchemes = protobuf.preferredStyleSchemes
        }

        if protobuf.hasSemantics {
            semantics = try Pass.Semantics(protobuf: protobuf.semantics)
        }

        if protobuf.hasAccessibilityURL {
            accessibilityURL = protobuf.accessibilityURL
        }

        if protobuf.hasAddOnURL {
            addOnURL = protobuf.addOnURL
        }

        if protobuf.hasAppLaunchURL {
            appLaunchURL = protobuf.appLaunchURL
        }

        if protobuf.hasBagPolicyURL {
            bagPolicyURL = protobuf.bagPolicyURL
        }

        if protobuf.hasMerchandiseURL {
            merchandiseURL = protobuf.merchandiseURL
        }

        if protobuf.hasOrderFoodURL {
            orderFoodURL = protobuf.orderFoodURL
        }

        if protobuf.hasParkingInformationURL {
            parkingInformationURL = protobuf.parkingInformationURL
        }

        if protobuf.hasPurchaseParkingURL {
            purchaseParkingURL = protobuf.purchaseParkingURL
        }

        if protobuf.hasSellURL {
            sellURL = protobuf.sellURL
        }

        if protobuf.hasTransferURL {
            transferURL = protobuf.transferURL
        }

        if protobuf.hasTransitInformationURL {
            transitInformationURL = protobuf.transitInformationURL
        }

        if protobuf.hasContactVenueEmail {
            contactVenueEmail = protobuf.contactVenueEmail
        }

        if protobuf.hasContactVenuePhoneNumber {
            contactVenuePhoneNumber = protobuf.contactVenuePhoneNumber
        }

        if protobuf.hasContactVenueWebsite {
            contactVenueWebsite = protobuf.contactVenueWebsite
        }

        if protobuf.hasDirectionsInformationURL {
            directionsInformationURL = protobuf.directionsInformationURL
        }

        if protobuf.hasChangeSeatURL {
            changeSeatURL = protobuf.changeSeatURL
        }

        if protobuf.hasEntertainmentURL {
            entertainmentURL = protobuf.entertainmentURL
        }

        if protobuf.hasPurchaseAdditionalBaggageURL {
            purchaseAdditionalBaggageURL = protobuf.purchaseAdditionalBaggageURL
        }

        if protobuf.hasPurchaseLoungeAccessURL {
            purchaseLoungeAccessURL = protobuf.purchaseLoungeAccessURL
        }

        if protobuf.hasPurchaseWifiURL {
            purchaseWifiURL = protobuf.purchaseWifiURL
        }

        if protobuf.hasUpgradeURL {
            upgradeURL = protobuf.upgradeURL
        }

        if protobuf.hasManagementURL {
            managementURL = protobuf.managementURL
        }

        if protobuf.hasRegisterServiceAnimalURL {
            registerServiceAnimalURL = protobuf.registerServiceAnimalURL
        }

        if protobuf.hasReportLostBagURL {
            reportLostBagURL = protobuf.reportLostBagURL
        }

        if protobuf.hasRequestWheelchairURL {
            requestWheelchairURL = protobuf.requestWheelchairURL
        }

        if protobuf.hasTransitProviderEmail {
            transitProviderEmail = protobuf.transitProviderEmail
        }

        if protobuf.hasTransitProviderPhoneNumber {
            transitProviderPhoneNumber = protobuf.transitProviderPhoneNumber
        }

        if protobuf.hasTransitProviderWebsiteURL {
            transitProviderWebsiteURL = protobuf.transitProviderWebsiteURL
        }

        if !protobuf.upcomingPassInformation.isEmpty {
            upcomingPassInformation = try protobuf.upcomingPassInformation.map {
                try Pass.UpcomingPassInformationEntry(protobuf: $0)
            }
        }

        if protobuf.hasLogoSymbolName {
            logoSymbolName = protobuf.logoSymbolName
        }
    }
}
