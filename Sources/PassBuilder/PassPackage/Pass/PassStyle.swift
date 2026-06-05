//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// The visual layout and behavior category of a pass.
public enum PassStyle: String, CaseIterable, Codable, Sendable {
    /// A boarding pass for air, rail, bus, or other transit.
    case boardingPass
    /// A ticket for an event such as a concert or sporting event.
    case eventTicket
    /// A coupon or promotional offer.
    case coupon
    /// A store loyalty or membership card.
    case storeCard
    /// A general-purpose pass.
    case generic
    /// A generic poster-style pass.
    case posterGeneric
}

extension PassStyle: Identifiable {
    /// The stable identity of the pass style, derived from its raw value.
    public var id: String { rawValue }
}

extension PassStyle: DefaultCodingProvider {
    /// The default pass style used when no explicit value is provided.
    static var defaultValue: Self { .generic }
}
