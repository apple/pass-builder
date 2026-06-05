//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation
@preconcurrency import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

/// Zips a file.
struct Zipper {
    enum ZipError: Error {
        case failedToZip
    }

    /// The URL of the file to zip.
    var inputURL: URL

    /// The URL to write the zipped file.
    var outputURL: URL

    /// Whether to remove the input file after successfully zipping and writing to output.
    var deleteOriginalInputOnSuccess: Bool = false

    /// Zip the input file and write its output.
    func run() async throws {
        var arguments = ["-r", "-q"]
        if deleteOriginalInputOnSuccess {
            arguments.append("-m")
        }
        arguments.append(contentsOf: [outputURL.path(percentEncoded: false), "."])

        let result = try await Subprocess.run(
            .name("zip"),
            arguments: Arguments(arguments),
            workingDirectory: FilePath(stringLiteral: inputURL.path(percentEncoded: false)),
            output: .discarded
        )

        if !result.terminationStatus.isSuccess {
            throw ZipError.failedToZip
        }
    }
}
