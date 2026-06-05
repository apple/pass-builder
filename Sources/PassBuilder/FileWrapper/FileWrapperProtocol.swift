//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A platform-independent wrapper around file system nodes.
///
/// On Apple platforms this delegates to `Foundation.FileWrapper`;
/// on Linux and Windows it uses ``PBFileWrapper`` instead.
struct FileWrapperContainer: Equatable {
#if os(Linux) || os(Windows)
    /// The platform-specific file wrapper type.
    typealias FileWrapperType = PBFileWrapper
#else
    /// The platform-specific file wrapper type.
    typealias FileWrapperType = Foundation.FileWrapper
#endif

    let wrapper: FileWrapperType

    /// Creates a file wrapper container by reading the file or directory at the given URL.
    init(url: URL) throws {
        self.wrapper = try FileWrapperType(url: url)
    }

    /// Creates a directory container with the specified child file wrappers.
    init(directoryWithFileWrappers childrenByPreferredName: [String: FileWrapperType]) {
        self.wrapper = FileWrapperType(directoryWithFileWrappers: childrenByPreferredName)
    }

    /// Creates a regular-file container with the given data contents.
    init(regularFileWithContents contents: Data) {
        self.wrapper = FileWrapperType(regularFileWithContents: contents)
    }

    /// Creates a container from an existing platform file wrapper.
    init(fileWrapper: FileWrapperType) {
        self.wrapper = fileWrapper
    }

    /// A Boolean value that indicates whether this container represents a directory.
    var isDirectory: Bool {
        wrapper.isDirectory
    }

    /// A Boolean value that indicates whether this container represents a regular file.
    var isRegularFile: Bool {
        wrapper.isRegularFile
    }

    /// The preferred name for the file or directory.
    var preferredFilename: String? {
        get { wrapper.preferredFilename }
        set { wrapper.preferredFilename = newValue }
    }

    /// The actual name of the file or directory on disk.
    var filename: String? {
        get { wrapper.filename }
        set { wrapper.filename = newValue }
    }

    /// The file system attributes for the represented file or directory.
    var fileAttributes: [String: Any] {
        get { wrapper.fileAttributes }
        set { wrapper.fileAttributes = newValue }
    }

    /// Replaces the container's contents by reading the file or directory at the given URL.
    func read(from url: URL) throws {
        try wrapper.read(from: url)
    }

    /// Writes the container's contents to the specified URL.
    func write(to url: URL, originalContentsURL: URL?) throws {
#if os(Linux) || os(Windows)
        try wrapper.write(to: url, originalContentsURL: originalContentsURL)
#else
        try wrapper.write(to: url, options: .atomic, originalContentsURL: originalContentsURL)
#endif
    }

    /// Adds a child file wrapper to this directory and returns the filename used as its key.
    func addFileWrapper(_ child: FileWrapperType) -> String {
        wrapper.addFileWrapper(child)
    }

    /// Creates a regular-file wrapper from data and adds it to this directory.
    @discardableResult
    func addRegularFile(withContents data: Data, preferredFilename fileName: String) -> String {
        wrapper.addRegularFile(withContents: data, preferredFilename: fileName)
    }

    /// Removes a child file wrapper from this directory.
    func removeFileWrapper(_ child: FileWrapperType) {
        wrapper.removeFileWrapper(child)
    }

    /// The child file wrappers contained in a directory, keyed by filename.
    var fileWrappers: [String: FileWrapperType]? {
        wrapper.fileWrappers
    }

    /// The raw data contents of a regular-file container.
    var regularFileContents: Data? {
        wrapper.regularFileContents
    }

}
