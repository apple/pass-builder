//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension FileWrapperContainer {
    // Adds a file to a FileWrapper directory. If the directory already contains a file with the same name, the
    // existing file is overwritten. This is opposed to `FileWrapper.addRegularFile` which keeps both files, generating
    // a new filename for subsequent conflicts.
    //
    // - Parameters:
    //   - contents: Contents for the new regular-file file wrapper.
    //   - fileName: Preferred filename for the new regular-file file wrapper.
    func addFileReplacingExisting(withContents contents: Data, preferredFilename fileName: String) {
        guard isDirectory, let fileWrappers else {
            assertionFailure("Attempting to add a file to a non-directory FileWrapper")
            return
        }

        if let existingWrapper = fileWrappers[fileName] {
            removeFileWrapper(existingWrapper)
        }

        addRegularFile(withContents: contents, preferredFilename: fileName)
    }
}
