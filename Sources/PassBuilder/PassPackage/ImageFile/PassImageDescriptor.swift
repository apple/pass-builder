//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// A property wrapper that associates a ``PassImage`` with a base filename and sizing constraint.
///
/// `PassImageDescriptor` is the source of truth for a named image slot on a pass. It owns the
/// base filename used when reading from or writing to a file wrapper, and the sizing constraint
/// that governs which image formats are accepted.
///
/// ```swift
/// @PassImageDescriptor("logo", size: .maximum(width: 160, height: 50))
/// var logo: PassImage
/// ```
///
/// Access the descriptor itself through the projected value (`$logo`) to call
/// methods such as ``name(for:)`` and ``fileName(for:)``.
@propertyWrapper
public struct PassImageDescriptor: Equatable, Sendable {
    /// The base filename for this image slot, without extension or scale suffix.
    public var name: String

    /// The sizing constraint for this image slot.
    public var size: Sizing

    /// The underlying ``PassImage`` containing all scale variants.
    public var wrappedValue: PassImage

    /// The descriptor exposed through the `$` projected-value syntax.
    public var projectedValue: PassImageDescriptor {
        get { self }
        set { self = newValue }
    }

    /// The underlying ``PassImage``, equivalent to ``wrappedValue``.
    public var image: PassImage {
        get { wrappedValue }
        set { wrappedValue = newValue }
    }

    /// Creates a ``PassImageDescriptor`` with the given name, sizing, and initial image.
    ///
    /// - Parameters:
    ///   - name: The base filename for this image slot.
    ///   - size: The sizing constraint for this image slot.
    ///   - wrappedValue: The initial ``PassImage``. Defaults to an empty image.
    public init(_ name: String, size: Sizing, wrappedValue: PassImage = PassImage()) {
        self.name = name
        self.size = size
        self.wrappedValue = wrappedValue
    }

    mutating func load(from parentFileWrapper: FileWrapperContainer) {
        wrappedValue.load(name, sizing: size, from: parentFileWrapper)
    }

    func wrap(into parentFileWrapper: FileWrapperContainer) {
        wrappedValue.wrap(name, into: parentFileWrapper)
    }

    /// Returns the scaled filename stem for the given image key path.
    ///
    /// Appends the appropriate scale suffix (`@2x`, `@3x`) to ``name`` based
    /// on which property the key path refers to. The 1× variant returns
    /// the base name unchanged.
    ///
    /// - Parameter keyPath: A key path into ``PassImage`` targeting a specific scale variant.
    /// - Returns: The filename stem including any scale suffix, such as `"logo@2x"`.
    public func name(for keyPath: KeyPath<PassImage, PassImageFile?>) -> String {
        switch keyPath {
        case \.times2: "\(name)@2x"
        case \.times3: "\(name)@3x"
        default: name
        }
    }

    /// Returns the full filename, including extension, for the given image key path.
    ///
    /// Combines the scaled name from ``name(for:)`` with the file extension of the
    /// image variant at `keyPath`. Returns `nil` if that variant has no assigned image.
    ///
    /// - Parameter keyPath: A key path into ``PassImage`` targeting a specific scale variant.
    /// - Returns: The full filename, such as `"logo@2x.png"`, or `nil` if the variant is empty.
    public func fileName(for keyPath: KeyPath<PassImage, PassImageFile?>) -> String? {
        guard let fileExtension = fileExtension(for: keyPath) else { return nil }
        return name(for: keyPath) + "." + fileExtension
    }

    private func fileExtension(for keyPath: KeyPath<PassImage, PassImageFile?>) -> String? {
        switch keyPath {
        case \.times1: image.times1?.fileType.fileExtension
        case \.times2: image.times2?.fileType.fileExtension
        case \.times3: image.times3?.fileType.fileExtension
        default: nil
        }
    }
}

public extension PassImageDescriptor {
    /// The expected dimensions for a pass image slot.
    enum Sizing: Equatable, Sendable {
        /// The image must match the specified width and height exactly.
        case required(width: Double, height: Double)
        /// The image must not exceed the specified width and height.
        case maximum(width: Double, height: Double)
    }

    /// The image file formats that a pass image slot supports.
    enum FileType: Sendable {
        /// A PNG image.
        case png
        /// A PDF image.
        case pdf

        /// Creates a ``FileType`` from the file extension of the given URL.
        ///
        /// Returns `nil` if the extension does not correspond to a supported format.
        ///
        /// - Parameter url: The URL whose path extension is examined.
        init?(url: URL) {
            switch url.pathExtension.lowercased() {
            case "png": self = .png
            case "pdf": self = .pdf
            default: return nil
            }
        }

        /// The file extension associated with this image format.
        public var fileExtension: String {
            switch self {
            case .png: "png"
            case .pdf: "pdf"
            }
        }
    }
}
