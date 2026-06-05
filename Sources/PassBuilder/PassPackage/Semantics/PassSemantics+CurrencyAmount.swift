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
    /// An object that represents an amount of money and type of currency.
    struct CurrencyAmount: Codable, Equatable, Sendable {
        /// The amount of money.
        public var amount: String?

        /// The currency code for amount. ISO 4217 currency code as a string.
        public var currencyCode: String?
    }
}
