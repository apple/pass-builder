//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation
import ArgumentParser
import PassBuilder

struct ValidatePassTool: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "validate",
        abstract: "Validate an uncompressed pass bundle."
    )

    @Argument(help: "The path to the pass.")
    var passPath: String

    public func run() async throws {
        let passURL = URL(filePath: passPath)
        let package = try PassPackage(url: passURL)

        let validator = PassValidator()
        let result = validator.validate(package)

        if result.issues.isEmpty {
            print("✓ No issues found with pass.")
            return
        }

        let sortedIssues = result.issues.sorted()
        let issueFormatter = CLIValidationIssueFormatStyle()

        for issue in sortedIssues {
            let output = issueFormatter.format(issue)
            print(output)
        }

        let hasError = result.issues.first(where: { $0.severity == .error }) != nil
        if hasError {
            throw ExitCode.validationFailure
        }
    }
}
