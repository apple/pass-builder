//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

private extension PassStyle {
    static let semanticBoardingPass = "semanticBoardingPass"
    static let posterEventTicket = "posterEventTicket"
}

public extension Pass {
    /// A Boolean value that indicates whether the pass supports its semantic-driven variant.
    var supportSemanticDrivenPassStyle: Bool {
        get {
            let styleSchemes = preferredStyleSchemes ?? []

            if boardingPass != nil {
                return styleSchemes.contains(PassStyle.semanticBoardingPass)
            }

            if eventTicket != nil {
                return styleSchemes.contains(PassStyle.posterEventTicket)
            }

            return false
        } set {
            var styleSchemes = preferredStyleSchemes ?? []

            if boardingPass != nil {
                styleSchemes = newValue ? [PassStyle.semanticBoardingPass, PassStyle.boardingPass.rawValue] : []
            }

            if eventTicket != nil {
                styleSchemes = newValue ? [PassStyle.posterEventTicket, PassStyle.eventTicket.rawValue] : []
            }

            self.preferredStyleSchemes = styleSchemes
        }
    }
}
