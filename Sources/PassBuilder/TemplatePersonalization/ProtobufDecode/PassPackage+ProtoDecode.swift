//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension PassPackage {
    mutating func extractMessage(from protobuf: PBPassPackage) throws {
        try pass.extractMessage(from: protobuf.pass)

        if protobuf.hasBackground {
            try background.extractMessage(from: protobuf.background)
        }
        if protobuf.hasArtwork {
            try artwork.extractMessage(from: protobuf.artwork)
        }
        if protobuf.hasFooter {
            try footer.extractMessage(from: protobuf.footer)
        }
        if protobuf.hasIcon {
            try icon.extractMessage(from: protobuf.icon)
        }
        if protobuf.hasLogo {
            try logo.extractMessage(from: protobuf.logo)
        }
        if protobuf.hasPrimaryLogo {
            try primaryLogo.extractMessage(from: protobuf.primaryLogo)
        }
        if protobuf.hasSecondaryLogo {
            try secondaryLogo.extractMessage(from: protobuf.secondaryLogo)
        }
        if protobuf.hasStrip {
            try strip.extractMessage(from: protobuf.strip)
        }
        if protobuf.hasThumbnail {
            try thumbnail.extractMessage(from: protobuf.thumbnail)
        }
    }
}
