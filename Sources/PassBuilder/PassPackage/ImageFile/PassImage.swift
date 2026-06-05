//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A set of scale variants representing a single pass image.
public struct PassImage: Equatable, Sendable {

    /// 1× image variant.
    public var times1: PassImageFile?

    /// 2× image variant.
    public var times2: PassImageFile?

    /// 3× image variant.
    public var times3: PassImageFile?

    /// Creates an empty ``PassImage`` with no scale variants.
    public init() {}

    /// Creates a ``PassImage`` by loading all available scale variants from disk.
    ///
    /// Derives the `@2x` and `@3x` variant URLs from `url` by inserting the
    /// appropriate scale suffix before the file extension. Variants whose
    /// files don't exist on disk are set to `nil`.
    ///
    /// - Parameter url: The URL of the 1× image file.
    /// - Throws: An error if reading an existing variant from disk fails.
    public init(url: URL) throws {
        times1 = try PassImageFile(url: url.scaleVariant(1))
        times2 = try PassImageFile(url: url.scaleVariant(2))
        times3 = try PassImageFile(url: url.scaleVariant(3))
    }

    mutating func load(
        _ name: String,
        sizing size: PassImageDescriptor.Sizing,
        from parentFileWrapper: FileWrapperContainer
    ) {
        times1 = PassImageFile(name.scaleVariant(1), sizing: size, parentFileWrapper: parentFileWrapper)
        times2 = PassImageFile(name.scaleVariant(2), sizing: size, parentFileWrapper: parentFileWrapper)
        times3 = PassImageFile(name.scaleVariant(3), sizing: size, parentFileWrapper: parentFileWrapper)
    }

    func wrap(_ name: String, into parentFileWrapper: FileWrapperContainer) {
        wrap(times1, name: name.scaleVariant(1), into: parentFileWrapper)
        wrap(times2, name: name.scaleVariant(2), into: parentFileWrapper)
        wrap(times3, name: name.scaleVariant(3), into: parentFileWrapper)
    }

    private func wrap(_ imageFile: PassImageFile?, name: String, into parentFileWrapper: FileWrapperContainer) {
        // A file wrapper may carry a cache of previously written files.
        // Any `PassImageFile` explicitly set to nil must be removed from
        // that cache — otherwise the stale file will be written to disk
        // and reappear on the next load.
        if let imageFile {
            imageFile.wrap(name, into: parentFileWrapper)
        } else {
            let fileWrapper = parentFileWrapper
                .fileWrappers?
                .first { $0.key.hasPrefix(name) }?
                .value
            if let fileWrapper {
                parentFileWrapper.removeFileWrapper(fileWrapper)
            }
        }
    }

    /// A Boolean value that indicates whether any scale variant has an assigned image.
    public var hasImage: Bool {
        times1 != nil || times2 != nil || times3 != nil
    }
}

private extension String {
    func scaleVariant(_ scale: Int) -> String {
        guard scale > 1 else { return self }
        return "\(self)@\(scale)x"
    }
}

private extension URL {
    func scaleVariant(_ scale: Int) -> URL {
        guard scale > 1 else { return self }
        let name = self.deletingPathExtension().lastPathComponent
        return self.deletingLastPathComponent()
                   .appendingPathComponent("\(name)@\(scale)x")
                   .appendingPathExtension(self.pathExtension)
    }
}
