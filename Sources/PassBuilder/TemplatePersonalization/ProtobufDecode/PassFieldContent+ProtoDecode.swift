//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.FieldContent {
    // swiftlint:disable:next cyclomatic_complexity
    init(protobuf: PBPassFieldContent) throws {
        key = protobuf.key

        if protobuf.hasLabel {
            label = protobuf.label
        }

        if protobuf.hasAttributedValue {
            attributedValue = protobuf.attributedValue
        }

        if protobuf.hasChangeMessage {
            changeMessage = protobuf.changeMessage
        }

        if !protobuf.dataDetectorTypes.isEmpty {
            dataDetectorTypes = try protobuf.dataDetectorTypes.compactMap { pbType in
                try Pass.DataDetectorType(protobuf: pbType)
            }
        }

        if protobuf.hasTextAlignment {
            textAlignment = try Pass.TextAlignment(protobuf: protobuf.textAlignment)
        }

        if protobuf.hasValue {
            decodeValue(from: protobuf.value)
        }

        if protobuf.hasDateStyle {
            dateStyle = try Pass.DateTimeFormat(protobuf: protobuf.dateStyle)
        }

        if protobuf.hasTimeStyle {
            timeStyle = try Pass.DateTimeFormat(protobuf: protobuf.timeStyle)
        }

        if protobuf.hasIgnoresTimeZone {
            ignoresTimeZone = protobuf.ignoresTimeZone
        }

        if protobuf.hasIsRelative {
            isRelative = protobuf.isRelative
        }

        if protobuf.hasNumberStyle {
            numberStyle = try Pass.NumberFormat(protobuf: protobuf.numberStyle)
        }

        if protobuf.hasCurrencyCode {
            currencyCode = protobuf.currencyCode
        }
    }

    mutating func decodeValue(from pbValue: PBPassFieldValue) {
        guard let value = pbValue.value else { return }

        switch value {
        case .valueText(let text): self.value = .text(text)
        case .valueAttributedText(let text): self.attributedValue = text
        case .valueDate(let timestamp): self.value = .date(Date(timeIntervalSince1970: timestamp.timeIntervalSince1970))
        case .valueInt(let int): self.value = .int(Int(int))
        case .valueDouble(let double): self.value = .double(double)
        }
    }
}
