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
    var fields: FieldsProxy {
        get {
            FieldsProxy(
                boardingPass: boardingPass,
                coupon: coupon,
                storeCard: storeCard,
                posterGeneric: posterGeneric,
                generic: generic,
                eventTicket: eventTicket
            )
        }
        _modify {
            var lens = FieldsProxy(
                boardingPass: boardingPass,
                coupon: coupon,
                storeCard: storeCard,
                posterGeneric: posterGeneric,
                generic: generic,
                eventTicket: eventTicket
            )
            yield &lens

            boardingPass = lens.boardingPass
            coupon = lens.coupon
            storeCard = lens.storeCard
            posterGeneric = lens.posterGeneric
            generic = lens.generic
            eventTicket = lens.eventTicket
        }
    }

    struct FieldsProxy {
        var boardingPass: Pass.Fields?
        var coupon: Pass.Fields?
        var storeCard: Pass.Fields?
        var posterGeneric: Pass.Fields?
        var generic: Pass.Fields?
        var eventTicket: Pass.Fields?

        public mutating func setValue(_ value: String, forKey fieldKey: String) {
            boardingPass?.setValue(.text(value), forKey: fieldKey)
            coupon?.setValue(.text(value), forKey: fieldKey)
            storeCard?.setValue(.text(value), forKey: fieldKey)
            posterGeneric?.setValue(.text(value), forKey: fieldKey)
            generic?.setValue(.text(value), forKey: fieldKey)
            eventTicket?.setValue(.text(value), forKey: fieldKey)
        }

        public mutating func setValue(_ value: Int, forKey fieldKey: String) {
            boardingPass?.setValue(.int(value), forKey: fieldKey)
            coupon?.setValue(.int(value), forKey: fieldKey)
            storeCard?.setValue(.int(value), forKey: fieldKey)
            posterGeneric?.setValue(.int(value), forKey: fieldKey)
            generic?.setValue(.int(value), forKey: fieldKey)
            eventTicket?.setValue(.int(value), forKey: fieldKey)
        }

        public mutating func setValue(_ value: Double, forKey fieldKey: String) {
            boardingPass?.setValue(.double(value), forKey: fieldKey)
            coupon?.setValue(.double(value), forKey: fieldKey)
            storeCard?.setValue(.double(value), forKey: fieldKey)
            posterGeneric?.setValue(.double(value), forKey: fieldKey)
            generic?.setValue(.double(value), forKey: fieldKey)
            eventTicket?.setValue(.double(value), forKey: fieldKey)
        }

        public mutating func setValue(_ value: Date, forKey fieldKey: String) {
            boardingPass?.setValue(.date(value), forKey: fieldKey)
            coupon?.setValue(.date(value), forKey: fieldKey)
            storeCard?.setValue(.date(value), forKey: fieldKey)
            posterGeneric?.setValue(.date(value), forKey: fieldKey)
            generic?.setValue(.date(value), forKey: fieldKey)
            eventTicket?.setValue(.date(value), forKey: fieldKey)
        }
    }
}
