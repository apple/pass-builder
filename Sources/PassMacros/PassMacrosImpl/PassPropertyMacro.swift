//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

/// Gets the pass property name and the property.
/// - Example: Calling `#passProperty($pass.foregroundColor)` transforms to an instance of
///            `PassProperty(name: "foregroundColor", value: $pass.foregroundColor)`.
public struct PassPropertyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression else {
            throw MacroExpansionError.message("Expected one argument.")
        }

        // Get the last component of property name.
        guard let argumentText = argument
            .description
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ".")
            .last else {
            throw MacroExpansionError.message("Unable to deconstruct argument.")
        }

        return
            """
            PassProperty(name: "\(raw: argumentText)", value: \(argument))
            """
    }
}
