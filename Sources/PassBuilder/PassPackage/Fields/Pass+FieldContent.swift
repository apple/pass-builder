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
    /// An object that represents the information to display in a field on a pass.
    struct FieldContent: Equatable, Identifiable, Sendable, Codable {
        /// (Required) A unique key that identifies a field in the pass; for example, “departure-gate”.
        public var key: String = ""

        /// The text for a field label.
        public var label: String?

        /// The value of the field, including HTML markup for links. The only supported tag is the `<a>` tag and its
        /// `href` attribute. The value of this key overrides that of the `value` key.
        /// For example, the following is a key-value pair that specifies a link with the text “Edit my profile”:
        /// `"attributedValue": "<a href='http://example.com/customers/123'>Edit my profile</a>"`
        /// The attributed value isn’t used for watchOS; use the `value` field instead.
        public var attributedValue: String?

        /// A format string for the alert text to display when the pass updates. The format string must contain
        /// the escape `%@`, which the field’s new value replaces. For example, `Gate changed to %@.`
        /// Provide a value for the system to show a change notification.
        /// This field isn’t used for watchOS.
        public var changeMessage: String?

        /// The data detectors to apply to the value of a field on the back of the pass. The default is to apply all
        /// data detectors. To use no data detectors, specify an empty array. You don’t use data detectors for fields on
        /// the front of the pass.
        /// This field isn’t used for watchOS.
        public var dataDetectorTypes: [Pass.DataDetectorType]?

        /// The alignment for the content of a field. The default is natural alignment, which aligns the text based on
        /// its script direction. This key is invalid for primary and back fields.
        public var textAlignment: Pass.TextAlignment? = .natural

        /// (Required) The value to use for the field; for example, `42`. A date or time value must include a
        /// time zone.
        public var fieldValue: Value {
            get { value }
            set { value = newValue }
        }

        @CodableDefault
        var value: Value = .text("")

        /// The style of the date to display in the field.
        public var dateStyle: Pass.DateTimeFormat?

        /// The style of the time displayed in the field.
        public var timeStyle: Pass.DateTimeFormat?

        /// A Boolean value that controls the time zone for the time and date to display in the field. The default
        /// value is false, which displays the time and date using the current device’s time zone. Otherwise, the
        /// time and date appear in the time zone associated with the date and time of value.
        /// This key doesn’t affect the pass relevance calculation.
        public var ignoresTimeZone: Bool?

        /// A Boolean value that controls whether the date appears as a relative date. The default value is false,
        /// which displays the date as an absolute date.
        /// This key doesn’t affect the pass relevance calculation.
        public var isRelative: Bool?

        /// The style of the number to display in the field. Formatter styles have the same meaning as the formats with
        /// corresponding names in NumberFormatter.Style.
        public var numberStyle: Pass.NumberFormat?

        /// The currency code to use for the value of the field.
        public var currencyCode: String?

        public init() {}

        public init(
            key: String,
            label: String,
            value: Value
        ) {
            self.key = key
            self.label = label
            self.value = value
        }

        /// An ID for the field.
        @_spi(PassDesigner)
        public var id: ItemID {
            get { _id }
            set { _id = newValue }
        }

        @CodableDefault var _id = ItemID()
    }
}
