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
    /// An object that represents the image specifications for the upcoming pass information entry.
    struct ImageURLEntry: Codable, Equatable, Sendable {
        /// (Required) The SHA256 hash of the image.
        public var sha256: String?

        /// (Required) The URL that points to the image asset to be downloaded. This must be an https link.
        public var url: String?

        /// The scale of the image. If unspecified, defaults to 1.
        public var scale: Double?

        /// Size of the image asset in bytes. The maximum allowed size is 2 megabytes.
        public var size: Int?
    }
}
