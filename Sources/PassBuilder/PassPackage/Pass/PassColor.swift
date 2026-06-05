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
    /// An object that represents a color for a pass.
    struct Color: Equatable, Sendable {
        /// The red weight of the color.
        public var red: Double

        /// The green weight of the color.
        public var green: Double

        /// The blue weight of the color.
        public var blue: Double

        public init(red: Double, green: Double, blue: Double) {
            self.red = red
            self.green = green
            self.blue = blue
        }
    }
}

extension Pass.Color: Codable {
    public enum DecodingError: Error, Equatable {
        case invalidRGB
        case invalidHex
        case unrecognizedFormat
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        let colorString = rawString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Wallet passes express colors as either an `rgb(r,g,b)` triple or a
        // HEX string (e.g. `#RRGGBB` / `#RGB`).
        if colorString.hasPrefix("#") {
            self = try Self.decodeHex(colorString)
        } else if colorString.lowercased().hasPrefix("rgb(") {
            self = try Self.decodeRGB(colorString)
        } else {
            throw DecodingError.unrecognizedFormat
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        let rgbString = "rgb(\(Int(red * 255)),\(Int(green * 255)),\(Int(blue * 255)))"
        try container.encode(rgbString)
    }

    // MARK: - Parsing

    private static func decodeRGB(_ string: String) throws -> Pass.Color {
        var rgbString = string.replacingOccurrences(of: " ", with: "", options: .caseInsensitive, range: nil)
        rgbString = rgbString.replacingOccurrences(of: "rgb(", with: "", options: .caseInsensitive, range: nil)
        rgbString = rgbString.replacingOccurrences(of: ")", with: "", options: .caseInsensitive, range: nil)
        let components = rgbString.components(separatedBy: ",")

        guard components.count == 3,
              let parsedRed = Int(components[0]),
              let parsedGreen = Int(components[1]),
              let parsedBlue = Int(components[2])
        else {
            throw DecodingError.invalidRGB
        }

        return Pass.Color(
            red: Double(parsedRed) / 255,
            green: Double(parsedGreen) / 255,
            blue: Double(parsedBlue) / 255
        )
    }

    private static func decodeHex(_ string: String) throws -> Pass.Color {
        var hex = string
        hex.removeFirst() // drop the leading "#"

        // Expand 3-digit shorthand (#RGB) into its 6-digit form (#RRGGBB).
        if hex.count == 3 {
            hex = hex.map { "\($0)\($0)" }.joined()
        }

        guard hex.count == 6,
              let value = UInt32(hex, radix: 16)
        else {
            throw DecodingError.invalidHex
        }

        return Pass.Color(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}
