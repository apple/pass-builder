# Preparing your certificate

Export a `.p12` certificate from a pass type certificate to sign Wallet passes.

## Overview

``PassSigner`` requires a `.p12` file to sign passes. Apple Developer provides pass type certificates as `.cer` files, so you need to import the certificate into Keychain Access and export it in the `.p12` format.

If you don't have a pass type certificate yet, follow the steps in [Create Wallet identifiers and certificates](https://developer.apple.com/help/account/capabilities/create-wallet-identifiers-and-certificates/) to register your pass type identifier and download the `.cer` file.

## Export a .p12 file

Import the certificate into Keychain Access and export it as a `.p12` file:

1. Double-click the downloaded `.cer` file to add it to your keychain.
2. In Keychain Access, find the certificate under **My Certificates**. It appears as "Pass Type ID:" followed by your identifier.
3. Click the disclosure triangle next to the certificate to confirm it has a private key attached.
4. Select the certificate (not the private key) and export the item.
5. Choose **Personal Information Exchange (.p12)** as the format.
6. Save the file and set a password when prompted. You use this password when you load the certificate with ``PassCertificate``.

> Important: Keep your `.p12` file and its password secure.

## Use the certificate

Pass the exported `.p12` file and password to ``PassCertificate`` to load it for signing:

```swift
let passCertificate = try PassCertificate(
    url: p12FileURL,
    password: "your-p12-password"
)
```

For the full signing process, see <doc:Signing_A_Pass>.
