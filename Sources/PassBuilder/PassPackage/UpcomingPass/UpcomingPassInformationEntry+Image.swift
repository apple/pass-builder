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
    /// An object that represents the image shown within the detail views of upcoming pass information entries.
    struct Image: Codable, Equatable, Sendable {
        /// A list of URLs used to retrieve an image. The upcoming pass information entry uses the item that best
        /// matches the device’s scale.
        public var urls: [ImageURLEntry]?

        /// A Boolean value that indicates whether to use the local equivalent image instead of the image specified by URLs.
        public var reuseExisting: Bool?
    }
}
