//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

let BuilderVersionString = "0.0.1"

@_spi(PassDesigner)
public struct Tooling: Equatable, Codable, Sendable {
    /// The Pass Designer version that created the template.
    public var designerVersion: String?
    /// The Pass Builder version that created the distributable package.
    public var builderVersion: String?
    /// A Boolean value that indicates whether to generate a compatibility variant of the pass for earlier versions of iOS.
    public var automaticallyGenerateCompatiblePass: Bool = false
}
