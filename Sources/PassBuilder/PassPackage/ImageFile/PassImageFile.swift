//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// The raw image data and format for a single scale variant of a pass image.
public struct PassImageFile: Equatable, Sendable {
    /// The raw image data.
    public var data: Data

    /// The format of the image.
    public var fileType: PassImageDescriptor.FileType

    /// Creates a ``PassImageFile`` with the given data and file type.
    ///
    /// - Parameters:
    ///   - data: The raw image data.
    ///   - fileType: The format of the image.
    public init(data: Data, fileType: PassImageDescriptor.FileType) {
        self.data = data
        self.fileType = fileType
    }

    /// Creates a ``PassImageFile`` by loading image data from the given URL.
    ///
    /// The file extension of `url` is used to determine the ``PassImageDescriptor/FileType``.
    ///
    /// - Parameter url: The local file URL to load from.
    /// - Throws: An error if the file extension does not correspond to a supported image format.
    public init(url: URL) throws {
        guard let fileType = PassImageDescriptor.FileType(url: url) else {
            throw CocoaError(.fileReadInvalidFileName)
        }
        self.fileType = fileType
        self.data = try Data(contentsOf: url, options: .mappedIfSafe)
    }

    /// Creates a ``PassImageFile`` by locating a matching file inside a file wrapper.
    ///
    /// Searches `parentFileWrapper` for a child file whose name matches `name` with a
    /// supported image extension. The set of supported extensions depends on the
    /// provided `size` and the active build configuration.
    ///
    /// Returns `nil` if no matching file is found.
    ///
    /// - Parameters:
    ///   - name: The base filename, without extension, to search for.
    ///   - size: The sizing constraint for this image slot, which determines
    ///     the file types to consider.
    ///   - parentFileWrapper: The file wrapper container to search within.
    init?(
        _ name: String,
        sizing size: PassImageDescriptor.Sizing,
        parentFileWrapper: FileWrapperContainer
    ) {
        let supportedFileTypes: [PassImageDescriptor.FileType] = [.pdf, .png]

        for type in supportedFileTypes {
            let fileWrapper = parentFileWrapper.fileWrappers?[name + "." + type.fileExtension]

            guard let fileWrapper, let data = fileWrapper.regularFileContents else {
                continue
            }

            self.data = data
            self.fileType = type
            return
        }

        return nil
    }

    func wrap(_ name: String, into parentFileWrapper: FileWrapperContainer) {
        parentFileWrapper.addFileReplacingExisting(
            withContents: data,
            preferredFilename: name + "." + fileType.fileExtension
        )
    }
}
