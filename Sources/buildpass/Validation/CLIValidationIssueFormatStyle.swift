//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation
import PassBuilder

struct CLIValidationIssueFormatStyle: FormatStyle {
    typealias FormatInput = PassValidationIssue
    typealias FormatOutput = String

    func format(_ value: PassValidationIssue) -> String {
        "\(formatSeverity(for: value)) \(value.message)"
    }

    private func formatSeverity(for issue: PassValidationIssue) -> String {
        switch issue.severity {
        case .warning: "▲ WARNING:"
        case .error: "✖ ERROR:"
        }
    }
}
