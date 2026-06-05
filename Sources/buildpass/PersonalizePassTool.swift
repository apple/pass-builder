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

struct PersonalizePassTool: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "personalize",
        abstract: "Personalize a pkpasstemplate with a Pass protobuf message."
    )

    @Argument(help: "The path to the pkpass template.")
    var templatePath: String

    @Option(help: "The path to the protobuf to personalize the template with.")
    var protobuf: String

    @Option(help: "The path to write the personalized pass.")
    var output: String

    public func run() throws {
        let templateURL = URL(filePath: templatePath)
        let protobufURL = URL(filePath: protobuf)

        let template = try PassPackage(url: templateURL)

        let personalizer = PassTemplatePersonalization()
        let personalizedPackage = try personalizer.personalize(
            template,
            protobufURL: protobufURL
        )

        let outputURL = URL(filePath: output)
        try personalizedPackage.write(to: outputURL)
    }
}
