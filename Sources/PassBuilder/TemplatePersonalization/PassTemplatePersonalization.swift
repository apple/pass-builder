//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A structure that personalizes pass templates from protobuf data.
///
/// Use this structure to transform a pass template into a personalized pass by applying specific data from a protobuf
/// message.
public struct PassTemplatePersonalization {
    /// Creates a new pass template personalizer.
    public init() { }

    /// Personalizes a pass template using data from a protobuf file.
    ///
    /// This method loads a pass template from the specified URL, extracts data from the protobuf file,
    /// and applies the data to create a personalized pass package.
    ///
    /// - Parameters:
    ///   - template: The pass template to personalize.
    ///   - protobufURL: The URL of the protobuf file containing personalization data.
    /// - Returns: A personalized ``PassPackage``.
    /// - Throws: An error if the file at `protobufURL` can't be read, or if the protobuf bytes can't be decoded
    ///   into a `PBPassPackage` and applied to the template.
    public func personalize(
        _ template: PassPackage,
        protobufURL: URL
    ) throws -> PassPackage {
        let protobufBytes = try Data(contentsOf: protobufURL)
        let protobufMessage = try PBPassPackage(serializedBytes: protobufBytes)

        let personalizedPass = try personalize(template, with: protobufMessage)
        return personalizedPass
    }

    /// Personalizes a pass template with data from a protobuf message.
    ///
    /// - Parameters:
    ///   - template: The pass template to personalize.
    ///   - protobuf: The protobuf message containing personalization data.
    /// - Returns: A personalized ``PassPackage``.
    /// - Throws: An error if the protobuf message can't be applied to the template.
    func personalize(
        _ template: PassPackage,
        with protobuf: PBPassPackage
    ) throws -> PassPackage {
        var template = template
        try template.extractMessage(from: protobuf)
        return template
    }
}
