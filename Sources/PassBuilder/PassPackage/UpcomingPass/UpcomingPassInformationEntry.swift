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
    /// An object that represents the ordered list of all upcoming pass information entries.
    struct UpcomingPassInformationEntry: Codable, Equatable, Sendable {
        /// A collection of URLs used to populate UI elements in the details view.
        public var urls: URLs?

        /// The fields of information displayed on the Additional Info section below a pass.
        public var additionalInfoFields: [Pass.FieldContent]?

        /// An array of App Store identifiers for apps associated with the upcoming pass information entry.
        /// The associated app on a device is the first item in the array that’s compatible with that device.
        /// This key works only for upcoming pass information entries for an event. A link to launch the app is in
        /// the event guide of the entry details view. If the app isn’t installed, the link opens to the App Store.
        public var auxiliaryStoreIdentifiers: [Int]?

        /// The fields of information displayed on the details view of the upcoming pass information entry.
        public var backFields: [Pass.FieldContent]?

        /// Information about the start and end time of the upcoming pass information entry.
        /// If omitted, the entry is labeled as TBD.
        public var dateInformation: DateInformation?

        /// (Required) A string that uniquely identifies the upcoming pass information entry.
        /// The identifier must be unique across upcoming pass information entries.
        public var identifier: String?

        /// A collection of image names used to populate images in the details view.
        public var images: Images?

        /// A Boolean value that indicates whether the upcoming pass information entry is currently active. The default value is `false`.
        public var isActive: Bool?

        /// (Required) The name of the upcoming pass information entry.
        public var name: String?

        /// The semantic, machine-readable metadata about the upcoming pass information entry.
        public var semantics: Pass.Semantics?

        /// (Required) The type of upcoming pass information entry.
        /// The only value currently supported is `event`.
        public var type: String?
    }
}
