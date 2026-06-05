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
    /// An object that represents a person's name.
    struct PersonName: Codable, Equatable, Sendable {
        /// The prefix for the person’s name, such as “Dr”.
        public var namePrefix: String?

        /// The person’s given name; also called the forename or first name in some countries.
        public var givenName: String?

        /// The person’s middle name.
        public var middleName: String?

        /// The person’s family name or last name.
        public var familyName: String?

        /// The suffix for the person’s name, such as “Junior”.
        public var nameSuffix: String?

        /// The person’s nickname.
        public var nickname: String?

        /// The phonetic representation of the person’s name.
        public var phoneticRepresentation: String?

        public init() { }

        public var isEmpty: Bool {
            familyName == nil &&
            givenName == nil &&
            middleName == nil &&
            namePrefix == nil &&
            nameSuffix == nil &&
            nickname == nil
        }
    }
}
