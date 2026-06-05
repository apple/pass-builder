//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass.UpcomingPassInformationEntry {
    /// A collection of image names used to populate images in the details view.
    struct Images: Codable, Equatable, Sendable {
        /// The name of the image file used for the header image on the details screen. This can be a remote asset.
        public var headerImage: Image?

        /// The name of the image file used for the venue map in the event guide for each upcoming pass
        /// information entry. This can be a remote asset and is available for event entries.
        public var venueMap: Image?
    }
}
