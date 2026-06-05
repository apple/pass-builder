# ``PassBuilder``

Programmatically create, sign, and distribute passes for Apple Wallet using a type-safe Swift API.

@Metadata {
    @DisplayName("Pass Builder")
}

## Overview

Pass Builder builds `.pkpass` bundles for distribution through Apple Wallet. Use it to populate templates created in Pass Designer, validate pass content, and sign packages with your pass type and WWDR certificates.

## Topics

### Personalizing pass templates

- <doc:Personalizing_Pass_Templates>
- ``PassTemplatePersonalization``

### Building and signing passes

- <doc:Preparing_Your_Certificate>
- <doc:Signing_A_Pass>
- ``PassCertificate``
- ``PassSigner``
- ``PassSigningError``

### Validating passes

- <doc:Validating_Passes>
- ``PassValidator``
- ``PassValidationPlugin``
- ``PassValidationResult``
- ``PassValidationIssue``
- ``PassValidationBuilder``
- ``PassPropertyDomain``

### Pass models

- ``PassPackage``
- ``Pass``
- ``PassStyle``
- ``PassImage``
- ``PassImageFile``
- ``PassImageDescriptor``
