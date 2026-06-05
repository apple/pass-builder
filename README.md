# Pass Builder

A Swift library and command-line tool for creating, validating, and signing Apple Wallet passes.

Pass Builder provides a type-safe API for constructing `.pkpass` bundles programmatically, with full support for all pass styles — boarding passes, event tickets, coupons, store cards, and more. It builds the `pass.json`, manages images, generates manifests, and cryptographically signs the bundle for distribution.

Pass Builder can also import `.pkpasstemplate` bundles created with Pass Designer for Mac, so you can visually design your pass and then use Pass Builder to personalize, build, and sign passes for distribution.

> **Early preview:** This package is in an early preview state. APIs may change without notice between releases. The package offers no stability guarantees at this time.

## Requirements

- Swift 6.3+
- macOS 14+ or Linux

## Installation

Add Pass Builder to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/apple/PassBuilder.git", from: "0.1.0")
]
```

Then add the library to your target's dependencies:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "PassBuilder", package: "PassBuilder")
    ]
)
```

## Usage

### Import a Pass Designer template

Load a `.pkpasstemplate` bundle created in Pass Designer:

```swift
import PassBuilder

let templateURL = URL(filePath: "/path/to/MyPass.pkpasstemplate")
let myPass = try PassPackage(url: templateURL)

// Customize the imported pass as needed
myPass.pass.serialNumber = "unique-serial-number"
```

### Sign a pass

Sign a pass directory with your certificates to produce a distributable `.pkpass` file:

```swift
let passCertificate = try PassCertificate(
    url: URL(filePath: "/path/to/pass-certificate.p12"),
    password: "certificate-password"
)

let wwdrCertificate = try PassCertificate(
    url: URL(filePath: "/path/to/wwdr-certificate.cer")
)

let signer = PassSigner(
    passCertificate: passCertificate,
    wwdrCertificate: wwdrCertificate
)

try await signer.signPass(
    myPass,
    destination: URL(filePath: "/path/to/MyPass.pkpass")
)
```

### Validate a pass

```swift
let validator = PassValidator()
let result = validator.validate(myPass)

for issue in result.issues {
    print(issue)
}
```

## Command-line tool

Pass Builder includes `buildpass`, a command-line tool for working with passes.

### Personalize a template

Apply a protobuf personalization payload to a pass template:

```bash
buildpass personalize /path/to/template.pkpasstemplate \
    --protobuf /path/to/personalization.pb \
    --output /path/to/PersonalizedPass.pass
```

### Sign a pass

```bash
buildpass sign /path/to/MyPass.pass \
    --pass-certificate /path/to/certificate.p12 \
    --wwdr-certificate /path/to/wwdr.cer
```

Provide the certificate password through the `BUILDPASS_PASS_CERTIFICATE_PASSWORD` environment variable. If you don't set it, `buildpass` prompts you interactively.

### Validate a pass

```bash
buildpass validate /path/to/MyPass.pass
```

## Certificates

To sign passes, you need:

1. **Pass Type ID certificate** — A `.p12` certificate registered in [Apple Developer Portal](https://developer.apple.com/account/) under Certificates, Identifiers & Profiles. This certificate must match the `passTypeIdentifier` in your pass.
2. **WWDR intermediate certificate** — The Apple Worldwide Developer Relations (WWDR) certificate, available from [the Apple Certificate Authority](https://www.apple.com/certificateauthority/).

## Contributing

Your contributions help shape the future of Pass Builder! We welcome contributors of all backgrounds and experience levels, recognizing that diverse perspectives drive better outcomes for everyone.

**How you can help**

* Reporting bugs with clear, reproducible steps as GitHub Issues 
* Improving documentation to make the project more accessible
* Triaging Issues by providing feedback, testing, and validation

We are not accepting pull requests for new enhancements and tests at launch while we learn how the community uses this project.
