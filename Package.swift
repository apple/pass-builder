// swift-tools-version: 6.3
//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PackageDescription
import CompilerPluginSupport

let internalSwiftSettings: [SwiftSetting] = [
]

let package = Package(
    name: "PassBuilder",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PassBuilder",
            targets: ["PassBuilder"]
        ),
        .executable(
            name: "buildpass",
            targets: ["buildpass", "PassBuilder"]
        ),
        .library(
            name: "PassMacros",
            targets: ["PassMacros"]
        ),
        .library(
            name: "PassPropertyProtocol",
            targets: ["PassPropertyProtocol"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-subprocess", from: "0.4.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax", "603.0.1"..<"605.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.6.1"),
        .package(url: "https://github.com/apple/swift-system", from: "1.6.4"),
        .package(url: "https://github.com/apple/swift-crypto", "3.14.0"..<"5.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf", from: "1.37.0"),
        .package(url: "https://github.com/apple/swift-certificates", from: "1.19.1"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.36.1"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "PassBuilder",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "X509", package: "swift-certificates"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .target(name: "PassMacros"),
                .target(name: "PlatformFoundation")
            ],
            resources: [
                .process("Resources/Localizable.xcstrings")
            ],
            swiftSettings: internalSwiftSettings
        ),
        .executableTarget(
            name: "buildpass",
            dependencies: [
                .byName(name: "PassBuilder"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            swiftSettings: internalSwiftSettings,
            linkerSettings: [
                // Both CCryptoBoringSSL and CNIOBoringSSL bundle libcxxabi when
                // statically linking against musl; allow the duplicate symbols.
                .unsafeFlags(["-Xlinker", "--allow-multiple-definition"],
                             .when(platforms: [.linux]))
            ]
        ),
        .macro(
            name: "PassMacrosImpl",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Sources/PassMacros/PassMacrosImpl"
        ),
        .target(
            name: "PassMacros",
            dependencies: ["PassMacrosImpl", "PassPropertyProtocol"],
            path: "Sources/PassMacros/PassMacros"
        ),
        .target(
            name: "PassPropertyProtocol",
            path: "Sources/PassMacros/PassPropertyProtocol"
        ),
        .target(
            name: "PlatformFoundation"
        )
    ]
)
