//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.UpcomingPassInformationEntry {
    init(protobuf: PBUpcomingPassInformationEntry) throws {
        identifier = protobuf.identifier
        name = protobuf.name
        type = protobuf.type

        if protobuf.hasUrls {
            urls = Pass.UpcomingPassInformationEntry.URLs(protobuf: protobuf.urls)
        }

        if protobuf.hasAdditionalInfoFields {
            additionalInfoFields = try protobuf
                .additionalInfoFields
                .fields
                .map { try Pass.FieldContent(protobuf: $0) }
        }

        if protobuf.hasBackFields {
            backFields = try protobuf
                .backFields
                .fields
                .map { try Pass.FieldContent(protobuf: $0) }
        }

        if !protobuf.auxiliaryStoreIdentifiers.isEmpty {
            auxiliaryStoreIdentifiers = protobuf.auxiliaryStoreIdentifiers.map { Int($0) }
        }

        if protobuf.hasDateInformation {
            dateInformation = Pass.UpcomingPassInformationEntry.DateInformation(protobuf: protobuf.dateInformation)
        }

        if protobuf.hasImages {
            images = Pass.UpcomingPassInformationEntry.Images(protobuf: protobuf.images)
        }

        if protobuf.isActive {
            isActive = protobuf.isActive
        }

        if protobuf.hasSemantics {
            semantics = try Pass.Semantics(protobuf: protobuf.semantics)
        }
    }
}

extension Pass.UpcomingPassInformationEntry.URLs {
    // swiftlint:disable:next cyclomatic_complexity
    init(protobuf: PBUpcomingPassInformationEntry.URLs) {
        if !protobuf.accessibilityURL.isEmpty {
            accessibilityURL = protobuf.accessibilityURL
        }

        if !protobuf.addOnURL.isEmpty {
            addOnURL = protobuf.addOnURL
        }

        if !protobuf.bagPolicyURL.isEmpty {
            bagPolicyURL = protobuf.bagPolicyURL
        }

        if !protobuf.contactVenueEmail.isEmpty {
            contactVenueEmail = protobuf.contactVenueEmail
        }

        if !protobuf.contactVenuePhoneNumber.isEmpty {
            contactVenuePhoneNumber = protobuf.contactVenuePhoneNumber
        }

        if !protobuf.contactVenueWebsite.isEmpty {
            contactVenueWebsite = protobuf.contactVenueWebsite
        }

        if !protobuf.directionsInformationURL.isEmpty {
            directionsInformationURL = protobuf.directionsInformationURL
        }

        if !protobuf.merchandiseURL.isEmpty {
            merchandiseURL = protobuf.merchandiseURL
        }

        if !protobuf.orderFoodURL.isEmpty {
            orderFoodURL = protobuf.orderFoodURL
        }

        if !protobuf.parkingInformationURL.isEmpty {
            parkingInformationURL = protobuf.parkingInformationURL
        }

        if !protobuf.purchaseParkingURL.isEmpty {
            purchaseParkingURL = protobuf.purchaseParkingURL
        }

        if !protobuf.sellURL.isEmpty {
            sellURL = protobuf.sellURL
        }

        if !protobuf.transferURL.isEmpty {
            transferURL = protobuf.transferURL
        }

        if !protobuf.transitInformationURL.isEmpty {
            transitInformationURL = protobuf.transitInformationURL
        }
    }
}

extension Pass.UpcomingPassInformationEntry.DateInformation {
    init(protobuf: PBUpcomingPassInformationEntry.DateInformation) {
        if protobuf.hasDate {
            date = Date(timeIntervalSince1970: protobuf.date.timeIntervalSince1970)
        }

        ignoreTimeComponents = protobuf.ignoreTimeComponents
        isAllDay = protobuf.isAllDay
        isUnannounced = protobuf.isUnannounced
        isUndetermined = protobuf.isUndetermined
        timeZone = protobuf.timeZone
    }
}

extension Pass.UpcomingPassInformationEntry.Images {
    init(protobuf: PBUpcomingPassInformationEntry.Images) {
        if protobuf.hasHeaderImage {
            headerImage = Pass.UpcomingPassInformationEntry.Image(protobuf: protobuf.headerImage)
        }

        if protobuf.hasVenueMap {
            venueMap = Pass.UpcomingPassInformationEntry.Image(protobuf: protobuf.venueMap)
        }
    }
}

extension Pass.UpcomingPassInformationEntry.Image {
    init(protobuf: PBUpcomingPassInformationEntry.Image) {
        if !protobuf.urls.isEmpty {
            urls = protobuf.urls.map { Pass.UpcomingPassInformationEntry.ImageURLEntry(protobuf: $0) }
        }

        if protobuf.reuseExisting {
            reuseExisting = protobuf.reuseExisting
        }
    }
}

extension Pass.UpcomingPassInformationEntry.ImageURLEntry {
    init(protobuf: PBUpcomingPassInformationEntry.ImageURLEntry) {
        if !protobuf.sha256.isEmpty {
            sha256 = protobuf.sha256
        }

        if !protobuf.url.isEmpty {
            url = protobuf.url
        }

        if protobuf.scale != 0 {
            scale = protobuf.scale
        }

        if protobuf.size != 0 {
            size = Int(protobuf.size)
        }
    }
}
