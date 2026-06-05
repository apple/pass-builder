//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// Parses date-time strings for Passes.
struct PassDateTimeFormatter {
    static func date(from string: String) -> Date? {
        guard hasWellFormedTimeZone(string) else { return nil }

        // Attempt to decode with and without fractional seconds.
        if let date = try? Date(string, strategy: secondsStrategy) {
            return date
        }
        if let date = try? Date(string, strategy: fractionalStrategy) {
            return date
        }

        // Passes allows "...HH:mm" with no seconds. Insert ":00" seconds, then parse.
        if let normalised = insertingZeroSeconds(into: string),
           let date = try? Date(normalised, strategy: secondsStrategy) {
            return date
        }

        return nil
    }

    private static let secondsStrategy = Date.ISO8601FormatStyle(includingFractionalSeconds: false)
    private static let fractionalStrategy = Date.ISO8601FormatStyle(includingFractionalSeconds: true)

    /// The time zone designator must terminate the string and be exactly `Z` or `±HH:MM`.
    /// `Date.ISO8601FormatStyle` accepts trailing characters after `Z`,
    /// so this guards whole-string matching to match Wallet passes.
    private static func hasWellFormedTimeZone(_ string: String) -> Bool {
        guard let timeSeparator = string.firstIndex(of: "T") else { return false }

        let zoneStart = string[string.index(after: timeSeparator)...]
            .firstIndex(where: { $0 == "Z" || $0 == "+" || $0 == "-" })

        guard let zoneStart else {
            return false
        }

        let zone = string[zoneStart...]
        if zone == "Z" {
            return true
        }

        // ±HH:MM — sign, two digits, colon, two digits, and nothing more.
        let characters = Array(zone)
        guard characters.count == 6 else { return false }

        guard characters[0] == "+" || characters[0] == "-" else { return false }

        guard characters[3] == ":" else { return false }

        return characters[1].isNumber && characters[2].isNumber
            && characters[4].isNumber && characters[5].isNumber
    }

    /// Turns "YYYY-MM-DDTHH:MM<tz>" into "YYYY-MM-DDTHH:MM:00<tz>" when the time has
    /// hours and minutes but no seconds.
    private static func insertingZeroSeconds(into string: String) -> String? {
        guard let timeSeparator = string.firstIndex(of: "T") else { return nil }

        let timeStart = string.index(after: timeSeparator)
        let zoneStart = string[timeStart...].firstIndex(where: { $0 == "Z" || $0 == "+" || $0 == "-" })

        guard let zoneStart else {
            return nil
        }

        let time = string[timeStart..<zoneStart]   // e.g. "18:00" or "18:00:00"
        let segments = time.count(where: { $0 == ":" })

        // Only handle the hours:minutes (one colon) case; everything else is
        // either already seconds-bearing or malformed.
        guard segments == 1 else { return nil }

        let adjustedString: String = string[string.startIndex..<zoneStart] + ":00" + string[zoneStart...]
        return adjustedString
    }
}
