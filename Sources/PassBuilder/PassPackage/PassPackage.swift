//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// An Apple Wallet pass bundle.
public struct PassPackage: Equatable {

    private var _pass = Pass()

    /// A representation of `pass.json`.
    public var pass: Pass {
        get { _pass }
        set {
            let fixedPass = PassFixits().fix(newValue)
            _pass = fixedPass
        }
    }

    /// The background image displayed behind the pass content.
    @PassImageDescriptor("background", size: .required(width: 345, height: 505))
    public var background

    /// The artwork image for poster event tickets.
    @PassImageDescriptor("artwork", size: .required(width: 358, height: 448))
    public var artwork

    /// The footer image displayed at the bottom of the pass.
    @PassImageDescriptor("footer", size: .maximum(width: 286, height: 15))
    public var footer

    /// The pass icon.
    @PassImageDescriptor("icon", size: .required(width: 38, height: 38))
    public var icon

    /// The logo image displayed at the top of the pass.
    @PassImageDescriptor("logo", size: .maximum(width: 160, height: 50))
    public var logo

    /// The primary logo displayed at the top of poster passes.
    @PassImageDescriptor("primaryLogo", size: .maximum(width: 126, height: 30))
    public var primaryLogo

    /// The secondary logo displayed on poster passes that include one.
    @PassImageDescriptor("secondaryLogo", size: .maximum(width: 135, height: 12))
    public var secondaryLogo

    /// The strip image displayed across the pass.
    @PassImageDescriptor("strip", size: .required(width: 375, height: 144))
    public var strip

    /// The thumbnail image for the pass.
    @PassImageDescriptor("thumbnail", size: .required(width: 90, height: 90))
    public var thumbnail

    @_spi(PassDesigner)
    public var tooling = Tooling()

    // Preserve the original directory contents so we don't discard file system data on save.
    private var originalFileWrappers = [String: FileWrapperContainer.FileWrapperType]()
    private var originalJSON: Data?

    /// A Boolean value that indicates whether this package was newly created and has not been saved.
    public var isNewDocument: Bool

    /// Creates an empty pass package for a new document.
    public init() {
        isNewDocument = true
        pass.generic = Pass.Fields()
    }

    /// Creates a pass package by reading the pass bundle at the given file URL.
    ///
    /// - Parameter url: The file URL of a pass bundle or `.pkpasstemplate` directory.
    /// - Throws: An error if the bundle can't be read, or if its `pass.json` can't be decoded,
    ///   including decoding errors thrown by `PassJSONDecoder`.
    public init(url: URL) throws {
        let container = try FileWrapperContainer(url: url)
        try self.init(fileWrapperContainer: container)
    }

    /// Creates a pass package by reading from a file wrapper container.
    ///
    /// - Throws: An error if the container's `pass.json` can't be decoded, including decoding errors
    ///   thrown by `PassJSONDecoder`.
    init(fileWrapperContainer: FileWrapperContainer) throws {
        isNewDocument = false

        guard fileWrapperContainer.isDirectory,
              let wrappers = fileWrapperContainer.fileWrappers,
              let passFileContents = wrappers[passJSONFileName]?.regularFileContents
        else {
            return
        }

        self.originalJSON = passFileContents
        self._pass = try decodePass(from: passFileContents)

        extractImages(from: fileWrapperContainer)

        if let wrappers = fileWrapperContainer.fileWrappers {
            self.originalFileWrappers = wrappers
        }

        if let toolsVersion = wrappers[toolingJSONFileName]?.regularFileContents {
            do {
                let decoder = PassJSONDecoder()
                self.tooling = try decoder.decode(Tooling.self, from: toolsVersion)
            } catch {}
        }
    }

    private mutating func extractImages(from fileWrapper: FileWrapperContainer) {
        _background.load(from: fileWrapper)
        _artwork.load(from: fileWrapper)
        _footer.load(from: fileWrapper)
        _icon.load(from: fileWrapper)
        _logo.load(from: fileWrapper)
        _primaryLogo.load(from: fileWrapper)
        _secondaryLogo.load(from: fileWrapper)
        _strip.load(from: fileWrapper)
        _thumbnail.load(from: fileWrapper)

    }

    private func encodeImages(into fileWrapper: FileWrapperContainer) {
        _background.wrap(into: fileWrapper)
        _artwork.wrap(into: fileWrapper)
        _footer.wrap(into: fileWrapper)
        _icon.wrap(into: fileWrapper)
        _logo.wrap(into: fileWrapper)
        _primaryLogo.wrap(into: fileWrapper)
        _secondaryLogo.wrap(into: fileWrapper)
        _strip.wrap(into: fileWrapper)
        _thumbnail.wrap(into: fileWrapper)

    }

    private mutating func decodePass(from data: Data) throws -> Pass {
        do {
            let decoder = PassJSONDecoder()
            let pass = try decoder.decode(Pass.self, from: data)
            return pass
        } catch {
            debugPrint("Failed to decode pass: \(error)")
            throw error
        }
    }

    /// Returns the resolved `pass.json` data, merging any unrecognized keys from the original file.
    ///
    /// - Returns: The encoded `pass.json` data with any unrecognized keys from the original file preserved.
    /// - Throws: An error if the pass can't be encoded as JSON, or if merging fails.
    public func resolvedPassJSON() throws -> Data {
        let pass = pass
        let merger = JSONMerger(codableObject: pass)
        let mergedData = try merger.merge(into: originalJSON)
        return mergedData
    }

    /// Returns a file wrapper that represents the complete pass bundle.
    ///
    /// - Returns: A file wrapper containing `pass.json`, `tooling.json`, and all assigned images.
    /// - Throws: An error if the pass can't be encoded; see ``resolvedPassJSON()``.
    func fileWrapper() throws -> FileWrapperContainer {
        let jsonData = try resolvedPassJSON()

        var directoryWrappers = originalFileWrappers
        directoryWrappers[passJSONFileName] = FileWrapperContainer.FileWrapperType(regularFileWithContents: jsonData)

        do {
            let encoder = PassJSONEncoder()
            let data = try encoder.encode(tooling)
            directoryWrappers[toolingJSONFileName] = FileWrapperContainer.FileWrapperType(regularFileWithContents: data)
        } catch {}

        let fileWrapper = FileWrapperContainer(directoryWithFileWrappers: directoryWrappers)
        encodeImages(into: fileWrapper)

        return fileWrapper
    }

    /// Writes the pass bundle to disk at the specified location.
    ///
    /// - Parameters:
    ///   - url: The location at which to write the pass bundle.
    ///   - originalContentsURL: The location of the bundle's previous on-disk
    ///     contents, if any. When you pass the destination's existing URL, the
    ///     write can reuse unchanged files instead of rewriting the entire
    ///     bundle. Pass `nil` when writing to a new location. The default is `nil`.
    /// - Throws: An error if the pass can't be encoded, or if the bundle can't be
    ///   written to `url`.
    public func write(to url: URL, originalContentsURL: URL? = nil) throws {
        try fileWrapper().write(to: url, originalContentsURL: originalContentsURL)
    }
}

private let passJSONFileName = "pass.json"
let toolingJSONFileName = "tooling.json"
