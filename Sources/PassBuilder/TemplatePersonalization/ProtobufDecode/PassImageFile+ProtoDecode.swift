//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension PassImageFile {
    init(protobuf: PBPassImageFile) throws {
        let imageURL = URL(filePath: protobuf.imagePath)
        guard imageURL.isFileURL else {
            throw ProtobufError.invalidValue(message: "Only local files are supported.")
        }
        self = try .init(url: imageURL)
    }
}
