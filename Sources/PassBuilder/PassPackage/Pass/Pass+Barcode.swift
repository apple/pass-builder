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
    /// An object that represents a barcode on a pass.
    struct Barcode: Equatable, Codable, Sendable {
        /// (Required) The format of the barcode.
        /// The barcode format `PKBarcodeFormatCode128` isn’t supported for watchOS.
        public var format: Pass.BarcodeFormat = .qr

        /// (Required) The message or payload to display as a barcode.
        public var message: String? = ""

        /// (Required) The IANA character set name of the text encoding to use to convert `message` from a string
        /// representation to a data representation that the system renders as a barcode, such as `iso-8859-1`.
        public var messageEncoding: String? = "iso-8859-1"

        /// The text to display near the barcode. For example, a human-readable version of the barcode data in case
        /// the barcode doesn’t scan.
        /// The alternative text isn’t displayed for watchOS.
        public var altText: String?

        public init() {}
    }
}

public extension Pass {
    enum BarcodeFormat: String, CaseIterable, Codable, Sendable {
        // swiftlint:disable:next identifier_name
        case qr = "PKBarcodeFormatQR"
        case pdf417 = "PKBarcodeFormatPDF417"
        case aztec = "PKBarcodeFormatAztec"
        case code128 = "PKBarcodeFormatCode128"
        case code39 = "PKBarcodeFormatCode39"
        case codabar = "PKBarcodeFormatCodabar"
        case ean13 = "PKBarcodeFormatEAN13"
        case i2of5 = "PKBarcodeFormatI2of5"
    }
}

extension Pass.BarcodeFormat: Identifiable {
    public var id: String { rawValue }
}
