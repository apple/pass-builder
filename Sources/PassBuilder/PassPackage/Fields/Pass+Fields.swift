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
    /// An object that represents the groups of fields that display information on the front and back of a pass.
    struct Fields: Equatable, Codable, Sendable {
        /// An object that represents the fields that display information at the top of a pass.
        public var headerFields: [Pass.FieldContent]?

        /// An object that represents the fields that display the most important information on a pass.
        public var primaryFields: [Pass.FieldContent]?

        /// An object that represents the fields that display supporting information on the front of a pass.
        public var secondaryFields: [Pass.FieldContent]?

        /// An object that represents the fields that display additional information on the front of a pass.
        public var auxiliaryFields: [Pass.FieldContent]?

        /// An object that represents the fields that display information on the back of a pass.
        public var backFields: [Pass.FieldContent]?

        /// An object that represents fields that display in the Additional Info section below a pass.
        public var additionalInfoFields: [Pass.FieldContent]?

        /// An object that represents fields that display in the footer of a pass face.
        public var footerFields: [Pass.FieldContent]?

        /// (Required for boarding-pass styles) The type of transit for a boarding pass. This key is invalid for other
        /// types of passes. The system may use the value to display more information, such as showing an airplane icon
        /// for the pass on watchOS when the value is set to `PKTransitTypeAir`.
        public var transitType: Pass.TransitType?

        public init() {}
    }
}

extension Pass.Fields {
    mutating func setValue(_ value: Pass.FieldContent.Value, forKey fieldKey: String) {
        headerFields = headerFields?.map {
            if $0.key == fieldKey {
                var copy = $0
                copy.value = value
                return copy
            }
            return $0
        }
        primaryFields = primaryFields?.map {
            if $0.key == fieldKey {
                var copy = $0
                copy.value = value
                return copy
            }
            return $0
        }
        secondaryFields = secondaryFields?.map {
            if $0.key == fieldKey {
                var copy = $0
                copy.value = value
                return copy
            }
            return $0
        }
        auxiliaryFields = auxiliaryFields?.map {
            if $0.key == fieldKey {
                var copy = $0
                copy.value = value
                return copy
            }
            return $0
        }
        backFields = backFields?.map {
            if $0.key == fieldKey {
                var copy = $0
                copy.value = value
                return copy
            }
            return $0
        }
        additionalInfoFields = additionalInfoFields?.map {
            if $0.key == fieldKey {
                var copy = $0
                copy.value = value
                return copy
            }
            return $0
        }
        footerFields = footerFields?.map {
            if $0.key == fieldKey {
                var copy = $0
                copy.value = value
                return copy
            }
            return $0
        }
    }
}

extension Pass.Fields: DefaultCodingProvider {
    static var defaultValue: Self { Pass.Fields() }
}
