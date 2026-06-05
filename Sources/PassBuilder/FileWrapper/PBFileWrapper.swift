//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A portable representation of a file or directory hierarchy, analogous to `FileWrapper`.
///
/// Use `PBFileWrapper` to read, modify, and write pass package contents
/// as an in-memory tree of files and directories.
final class PBFileWrapper {
    /// A Boolean value that indicates whether this wrapper represents a directory.
    let isDirectory: Bool
    /// A Boolean value that indicates whether this wrapper represents a regular file.
    let isRegularFile: Bool
    /// The preferred name for the file or directory.
    var preferredFilename: String?
    /// The actual name of the file or directory on disk.
    var filename: String?
    /// The file system attributes for the represented file or directory.
    var fileAttributes: [String: Any]

    private enum FileType {
        case directory
        case regularFile
    }

    private enum ChildrenState {
        case none
        case loaded([String: PBFileWrapper])
        case deferred(URL)
    }

    private let type: FileType
    private var childrenState: ChildrenState
    private var contents: Data?

    private var children: [String: PBFileWrapper]? {
        get {
            switch childrenState {
            case .none:
                return nil
            case .loaded(let wrappers):
                return wrappers
            case .deferred(let url):
                let loaded = (try? Self.loadChildren(from: url)) ?? [:]
                childrenState = .loaded(loaded)
                return loaded
            }
        }
        set {
            if let newValue {
                childrenState = .loaded(newValue)
            } else {
                childrenState = .none
            }
        }
    }

    /// The child file wrappers contained in a directory wrapper, keyed by filename.
    var fileWrappers: [String: PBFileWrapper]? {
        return children as [String: PBFileWrapper]?
    }

    /// The raw data contents of a regular-file wrapper.
    var regularFileContents: Data? {
        guard isRegularFile else { return nil }
        return contents
    }

    /// Creates a file wrapper by reading the file or directory at the given URL.
    init(url: URL) throws {
        let fileManager = FileManager.default

        // Reject symbolic links to prevent symlink-based path traversal attacks.
        // A symlink inside a pass bundle could otherwise point to arbitrary paths
        // on the host (e.g. /etc/passwd) and have their contents silently loaded.
        let resourceValues = try? url.resourceValues(forKeys: [.isSymbolicLinkKey])
        guard resourceValues?.isSymbolicLink != true else {
            throw CocoaError(.fileReadUnknown)
        }

        let (fileExists, isDirectory) = fileManager.fileExists(atPath: url.path)
        guard fileExists else { throw CocoaError(.fileReadNoSuchFile) }

        if isDirectory {
            self.type = .directory
            self.isDirectory = true
            self.isRegularFile = false
            self.childrenState = .deferred(url)
            self.contents = nil
            self.preferredFilename = url.lastPathComponent
            self.filename = url.lastPathComponent
            self.fileAttributes = [:]
        } else {
            self.type = .regularFile
            self.isDirectory = false
            self.isRegularFile = true
            self.childrenState = .none
            self.contents = try Data(contentsOf: url)
            self.preferredFilename = url.lastPathComponent
            self.filename = url.lastPathComponent
            self.fileAttributes = [:]
        }

        if let attrs = try? fileManager.attributesOfItem(atPath: url.path) {
            var stringKeyAttrs: [String: Any] = [:]
            for (key, value) in attrs {
                stringKeyAttrs[key.rawValue] = value
            }
            self.fileAttributes = stringKeyAttrs
        }
    }

    /// Creates a directory wrapper with the specified child file wrappers.
    init(directoryWithFileWrappers childrenByPreferredName: [String: PBFileWrapper]) {
        self.type = .directory
        self.isDirectory = true
        self.isRegularFile = false
        self.childrenState = .loaded(childrenByPreferredName)
        self.contents = nil
        self.preferredFilename = nil
        self.filename = nil
        self.fileAttributes = [:]
    }

    /// Creates a regular-file wrapper with the given data contents.
    init(regularFileWithContents contents: Data) {
        self.type = .regularFile
        self.isDirectory = false
        self.isRegularFile = true
        self.childrenState = .none
        self.contents = contents
        self.preferredFilename = nil
        self.filename = nil
        self.fileAttributes = [:]
    }

    /// Replaces the wrapper's contents by reading the file or directory at the given URL.
    func read(from url: URL) throws {
        let fileManager = FileManager.default

        let resourceValues = try? url.resourceValues(forKeys: [.isSymbolicLinkKey])
        guard resourceValues?.isSymbolicLink != true else {
            throw CocoaError(.fileReadUnknown)
        }

        let (fileExists, isDirectory) = fileManager.fileExists(atPath: url.path)
        guard fileExists else { throw CocoaError(.fileReadNoSuchFile) }

        if isDirectory {
            self.childrenState = .deferred(url)
        } else {
            self.contents = try Data(contentsOf: url)
        }

        self.filename = url.lastPathComponent
        self.preferredFilename = url.lastPathComponent

        if let attrs = try? fileManager.attributesOfItem(atPath: url.path) {
            var stringKeyAttrs: [String: Any] = [:]
            for (key, value) in attrs {
                stringKeyAttrs[key.rawValue] = value
            }
            self.fileAttributes = stringKeyAttrs
        }
    }

    private static func loadChildren(from url: URL) throws -> [String: PBFileWrapper] {
        // Include .isSymbolicLinkKey so we can filter out symlinks before recursing.
        let items = try FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isSymbolicLinkKey]
        )
        var children: [String: PBFileWrapper] = [:]
        for itemURL in items {
            // Skip symbolic links to prevent a malicious pass bundle from
            // using them to read arbitrary files outside the pass directory.
            let resourceValues = try? itemURL.resourceValues(forKeys: [.isSymbolicLinkKey])
            guard resourceValues?.isSymbolicLink != true else { continue }

            let childWrapper = try PBFileWrapper(url: itemURL)
            let name = itemURL.lastPathComponent
            childWrapper.preferredFilename = name
            childWrapper.filename = name
            children[name] = childWrapper
        }
        return children
    }

    /// Writes the wrapper's contents to the specified URL.
    func write(to url: URL, originalContentsURL: URL?) throws {
        let fileManager = FileManager.default

        var attributes: [FileAttributeKey: Any] = [:]
        for (key, value) in fileAttributes {
            attributes[FileAttributeKey(rawValue: key)] = value
        }

        if isDirectory {
            try fileManager.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: attributes
            )

            let children = children ?? [:]
            for (name, wrapper) in children {
                let childURL = url.appendingPathComponent(name)
                try wrapper.write(to: childURL, originalContentsURL: originalContentsURL)
            }
        } else if let contents = contents {
            try contents.write(to: url, options: .atomic)
            try fileManager.setAttributes(
                attributes,
                ofItemAtPath: url.path
            )
        }
    }

    /// Adds a child file wrapper to this directory and returns the filename used as its key.
    func addFileWrapper(_ child: PBFileWrapper) -> String {
        guard isDirectory else {
            fatalError("Cannot add file wrapper to a non-directory")
        }

        var children = children ?? [:]

        let filename = child.filename ?? child.preferredFilename ?? UUID().uuidString
        child.filename = filename
        child.preferredFilename = filename
        children[filename] = child

        self.children = children

        return filename
    }

    /// Creates a regular-file wrapper from data and adds it to this directory.
    func addRegularFile(withContents data: Data, preferredFilename fileName: String) -> String {
        guard isDirectory else {
            fatalError("Cannot add file to a non-directory")
        }

        var children = children ?? [:]

        let fileWrapper = PBFileWrapper(regularFileWithContents: data)
        fileWrapper.preferredFilename = fileName
        fileWrapper.filename = fileName
        children[fileName] = fileWrapper

        self.children = children

        return fileName
    }

    /// Removes a child file wrapper from this directory.
    func removeFileWrapper(_ child: PBFileWrapper) {
        guard isDirectory else { return }
        children = children?.filter { $0.value !== child }
    }
}

extension PBFileWrapper: Equatable {
    static func == (lhs: PBFileWrapper, rhs: PBFileWrapper) -> Bool {
        // Check if types match
        guard lhs.type == rhs.type else { return false }

        // Check filenames
        guard lhs.preferredFilename == rhs.preferredFilename,
              lhs.filename == rhs.filename else { return false }

        // Check type-specific properties
        switch lhs.type {
        case .directory:
            // Compare children
            guard let lhsChildren = lhs.children,
                  let rhsChildren = rhs.children,
                  lhsChildren.count == rhsChildren.count else {
                return lhs.children == nil && rhs.children == nil
            }

            for (key, lhsChild) in lhsChildren {
                guard let rhsChild = rhsChildren[key] else {
                    return false
                }

                guard lhsChild == rhsChild else {
                    return false
                }
            }
            return true

        case .regularFile:
            // Compare file contents
            return lhs.contents == rhs.contents
        }
    }
}
