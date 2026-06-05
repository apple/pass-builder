//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.BarcodeFormat {
    init(protobuf: PBPassBarcodeFormat) throws {
        switch protobuf {
        case .barcodeFormatQr: self = .qr
        case .barcodeFormatAztec: self = .aztec
        case .barcodeFormatPdf417: self = .pdf417
        case .barcodeFormatCode128: self = .code128
        case .barcodeFormatEan13: self = .ean13
        case .barcodeFormatCode39: self = .code39
        case .barcodeFormatI2Of5: self = .i2of5
        case .barcodeFormatCodabar: self = .codabar
        default: throw ProtobufError.invalidValue(message: "PassBarcodeFormat type is not recognized.")
        }
    }
}
