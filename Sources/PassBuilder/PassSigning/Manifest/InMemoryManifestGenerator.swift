//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// Generate the manifest for a pass.
struct InMemoryManifestGenerator {
    /// Generate the manifest of the pass.
    /// - Parameter package: The package to generate a manifest for.
    /// - Returns: The manifest of the pass.
    func generateManifest(for fileWrapper: FileWrapperContainer) async throws -> FileWrapperContainer.FileWrapperType {
        let manifest = await manifestDictionary(from: fileWrapper)
        let manifestData = try JSONEncoder().encode(manifest)
        let manifestFile = FileWrapperContainer.FileWrapperType(regularFileWithContents: manifestData)
        manifestFile.preferredFilename = "manifest.json"
        return manifestFile
    }

    private func manifestDictionary(from root: FileWrapperContainer) async -> [String: String] {
        let files = collectRegularFiles(from: root)

        guard !files.isEmpty else { return [:] }

        return await withTaskGroup(of: (String, String).self) { group in
            for (path, data) in files {
                group.addTask {
                    (path, data.sha1Hash())
                }
            }

            var manifest = [String: String](minimumCapacity: files.count)
            for await (path, hash) in group {
                manifest[path] = hash
            }
            return manifest
        }
    }

    private func collectRegularFiles(from root: FileWrapperContainer) -> [(path: String, data: Data)] {
        var files: [(path: String, data: Data)] = []
        var stack: [(container: FileWrapperContainer, prefix: String)] = [(root, "")]

        while let (current, prefix) = stack.popLast() {
            guard let children = current.fileWrappers else { continue }

            for (filename, child) in children {
                let relativePath = prefix.isEmpty ? filename : prefix + "/" + filename
                let container = FileWrapperContainer(fileWrapper: child)

                if container.isRegularFile {
                    if let data = container.regularFileContents {
                        files.append((relativePath, data))
                    }
                } else if container.isDirectory {
                    stack.append((container, relativePath))
                }
            }
        }

        return files
    }
}
