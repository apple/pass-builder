//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension FileManager {
    func fileExists(atPath path: String) -> (fileExists: Bool, isDirectory: Bool) {
        #if os(Linux)
        var isDirectory: Bool = false
        guard fileExists(atPath: path, isDirectory: &isDirectory) else {
            return (false, false)
        }
        return (true, isDirectory)
        #else
        var isDirectory: ObjCBool = false
        guard fileExists(atPath: path, isDirectory: &isDirectory) else {
            return (false, false)
        }
        return (true, isDirectory.boolValue)
        #endif
    }
}
