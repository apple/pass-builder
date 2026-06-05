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

struct SignPassTool: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sign",
        abstract: "Build and sign a Wallet Pass bundle for distribution."
    )

    @Argument(help: "The path to the pass to sign.")
    var passPath: String

    @Option(help: "The path to the .p12 certificate file to sign the pass.")
    var passCertificate: String

    @Option(help: "The path to the WWDR intermediate cert.")
    var wwdrCertificate: String

    @Option(help: "Whether to zip the written pass.")
    var zipOutput: Bool = true

    @Option(help: "The path to write the pass file. If no output path is specified, the input pass path will be used.")
    var output: String?

    @Flag(help: "Overwrite an existing file if a file already exists at `outputPath`.")
    var overwriteExisting: Bool = false

    public func run() async throws {
        let wwdrCertificateURL = URL(filePath: wwdrCertificate)
        let wwdrCertificate = try PassCertificate(url: wwdrCertificateURL, password: nil)

        let outputURL: URL? = if let output {
            URL(filePath: output)
        } else {
            nil
        }

        let passURL = URL(filePath: passPath)
        let passCertificateURL = URL(filePath: passCertificate)
        var password = ProcessInfo.processInfo.environment["BUILDPASS_PASS_CERTIFICATE_PASSWORD"] ?? ""
        let passCertificate: PassCertificate

        do {
            passCertificate = try PassCertificate(url: passCertificateURL, password: password)
        } catch PassSigningError.badPassword {
            if password.isEmpty {
                password = try readCredential(prompt: "Certificate Password: ")
                passCertificate = try PassCertificate(url: passCertificateURL, password: password)
            } else {
                throw PassSigningError.badPassword
            }
        }

        var signingOptions = PassSigner.SigningOptions()

        if zipOutput {
            signingOptions.insert(.zipOutput)
        }

        if overwriteExisting {
            signingOptions.insert(.overwriteExisting)
        }

        let builder = PassSigner(
            passCertificate: passCertificate,
            wwdrCertificate: wwdrCertificate
        )

        _ = try await builder.signPass(at: passURL, destination: outputURL, options: signingOptions)
    }
}
