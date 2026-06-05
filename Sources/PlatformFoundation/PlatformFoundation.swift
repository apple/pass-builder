//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

// On Linux we want to import FoundationEssentials.

#if canImport(FoundationEssentials)
@_exported import FoundationEssentials
#else
@_exported import Foundation
#endif
