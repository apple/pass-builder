# Signing a pass

Sign a pass package with your certificates to produce a distributable `.pkpass` file.

## Overview

Before you can distribute a Wallet pass, you need to sign it with two certificates. The pass certificate identifies your pass type. The Apple Worldwide Developer Relations (WWDR) intermediate certificate chains the pass to Apple.

``PassSigner`` handles the signing process for you. It generates a manifest, creates a CMS signature, and compresses the result into a `.pkpass` file.

## Prepare your certificates

You need two certificates to sign a pass:

1. **Pass certificate** — A `.p12` file tied to your registered pass type identifier. See <doc:Preparing_Your_Certificate>.
2. **WWDR certificate** — The Apple WWDR intermediate certificate, available from the [Apple Certificate Authority](https://www.apple.com/certificateauthority/) page.

Load both certificates using ``PassCertificate``:

```swift
let passCertificate = try PassCertificate(
    url: passCertificateURL,
    password: "your-p12-password"
)

let wwdrCertificate = try PassCertificate(
    url: wwdrCertificateURL
)
```

> Note: If you omit the `password` parameter, ``PassCertificate`` attempts to load the file without a password.

## Verify certificate attributes

Before signing, verify that your pass certificate matches the pass you want to sign. Use ``PassCertificate/Attributes`` to check the embedded team identifier and pass type identifier:

```swift
let attributes = passCertificate.attributes
try attributes.validateAttributes(for: pass)
```

This throws ``PassSigningError`` if the certificate doesn't match the pass's `teamIdentifier` or `passTypeIdentifier`.

## Sign the pass

Create a ``PassSigner`` with both certificates, then call its ``PassSigner/signPass(at:destination:options:)`` method with your unsigned pass directory and an output URL:

```swift
let signer = PassSigner(
    passCertificate: passCertificate,
    wwdrCertificate: wwdrCertificate
)

try await signer.signPass(
    at: unsignedPassDirectoryURL,
    destination: outputURL
)
```

> Important: The `outputURL` must have the `.pkpass` file extension.

After ``PassSigner/signPass(at:destination:options:)`` returns, the signed `.pkpass` file is at your output URL and ready for distribution.

> Note: If a file already exists at the output URL, ``PassSigner`` throws an error. Pass `.overwriteExisting` in the `options` set to replace the existing file instead.
