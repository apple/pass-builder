//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

public extension Pass.Semantics {
    /// An object that contains information required to connect to a Wi-Fi network.
    struct WifiNetwork: Codable, Equatable, Sendable {
        /// (Required) The name for the Wi-Fi network.
        public var ssid: String?
        /// (Required) The password for the Wi-Fi network.
        public var password: String?

        public init() {}
    }
}
