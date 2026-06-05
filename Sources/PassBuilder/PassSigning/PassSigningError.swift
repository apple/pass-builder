//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// An error that occurs when signing a pass.
public enum PassSigningError: Error, Equatable {
    /// An incorrect password for the associated key file.
    case badPassword

    /// The provided certificate isn't valid for signing a pass.
    case certificateInvalid

    /// The certificate is valid, but doesn't match the pass's identifiers.
    ///
    /// The certificate is valid, but its team or pass type doesn't match the values in the pass's
    /// `pass.json`. The certificate's `passTypeIdentifier` and team ID must both match the pass.
    ///
    /// - Parameters:
    ///   - teamID: The team ID found in the certificate.
    ///   - passTypeID: The pass type identifier found in the certificate.
    case certificateAttributesMismatch(teamID: String, passTypeID: String)

    /// The certificate chain is empty.
    case certificateChainEmpty

    /// An unknown error from an underlying signing tool, with the tool's raw output.
    case unknownError(output: String)
}
