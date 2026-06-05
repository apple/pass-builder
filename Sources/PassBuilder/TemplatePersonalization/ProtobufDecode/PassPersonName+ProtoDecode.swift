//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.PersonName {
    init(protobuf: PBPassPersonName) {
        namePrefix = protobuf.namePrefix.isEmpty ? nil : protobuf.namePrefix
        givenName = protobuf.givenName.isEmpty ? nil : protobuf.givenName
        middleName = protobuf.middleName.isEmpty ? nil : protobuf.middleName
        familyName = protobuf.familyName.isEmpty ? nil : protobuf.familyName
        nameSuffix = protobuf.nameSuffix.isEmpty ? nil : protobuf.nameSuffix
        nickname = protobuf.nickname.isEmpty ? nil : protobuf.nickname
        phoneticRepresentation = protobuf.phoneticRepresentation.isEmpty ? nil : protobuf.phoneticRepresentation
    }
}
