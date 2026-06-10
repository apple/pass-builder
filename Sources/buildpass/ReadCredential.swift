//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif
import PlatformFoundation

enum PasswordError: Error {
    case couldNotOpenTTY
    case couldNotReadInput
}

func readCredential(prompt: String) throws -> String {
    guard let tty = fopen("/dev/tty", "r+") else {
        throw PasswordError.couldNotOpenTTY
    }
    defer { fclose(tty) }

    let ttyFD = fileno(tty)

    fputs(prompt, tty)
    fflush(tty)

    var oldTermios = termios()
    tcgetattr(ttyFD, &oldTermios)

    var newTermios = oldTermios
    newTermios.c_lflag &= ~tcflag_t(ECHO)
    tcsetattr(ttyFD, TCSAFLUSH, &newTermios)

    defer {
        tcsetattr(ttyFD, TCSAFLUSH, &oldTermios)
        fputs("\n", tty)
    }

    // Read directly from tty, not stdin
    var buffer = [CChar](repeating: 0, count: 1024)
    defer {
        _ = buffer.withUnsafeMutableBytes { ptr in
            #if canImport(Darwin)
            memset_s(ptr.baseAddress, ptr.count, 0, ptr.count)
            #else
            if let base = ptr.baseAddress {
                explicit_bzero(base, ptr.count)
            }
            #endif
        }
    }
    guard fgets(&buffer, Int32(buffer.count), tty) != nil else {
        throw PasswordError.couldNotReadInput
    }

    return String(cString: buffer).trimmingCharacters(in: .newlines)
}
