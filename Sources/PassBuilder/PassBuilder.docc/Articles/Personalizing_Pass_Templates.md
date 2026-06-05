# Personalizing pass templates

Personalize a pass template with real data to create a distributable Wallet pass.

## Overview

Pass Designer creates `.pkpasstemplate` files that define the structure and appearance of a Wallet pass. Before you sign and distribute a pass, you need to populate the template with real data like names, dates, and seat numbers.

Pass Builder gives you two ways to do this:

- **Directly with ``PassPackage``** — Load the template and configure assets and properties using the model APIs.
- **With ``PassTemplatePersonalization``** — Apply a protobuf message to the template. Use this approach when you receive personalization data from a server in protobuf format.

## Personalize a pass package

Load a `.pkpasstemplate` file into a ``PassPackage`` and set the values you need on its ``PassPackage/pass`` property:

```swift
let templateURL = URL(filePath: "/path/to/Event.pkpasstemplate")
var package = try PassPackage(url: templateURL)

package.pass.organizationName = "Example Events"
package.pass.serialNumber = "E-20260901-00042"
package.pass.description = "Admission to Music Event"

// Set the field content.
package.pass.fields.setValue(.text("Jazz Concert"), forKey: "eventName")
package.pass.fields.setValue(.date(Date()), forKey: "eventDate")
```

After you populate the template, write the pass to disk using the file wrapper.

```swift
let outputURL = URL(filePath: "/path/to/PersonalizedEvent")
let fileWrapper = try package.fileWrapper()
try fileWrapper.write(to: outputURL)
```

After you write the pass to disk, sign it to produce a `.pkpass` file.

See <doc:Signing_A_Pass> for the full signing process.

## Personalize with a protobuf message

If your server sends personalization data as a protobuf message, use ``PassTemplatePersonalization`` to apply it to a template. The message maps fields onto the pass.

```swift
let personalizer = PassTemplatePersonalization()

let package = try personalizer.personalize(
    template,
    protobufURL: URL(filePath: "/path/to/personalization.pb")
)
```

This loads the template, decodes the protobuf file, and returns a ``PassPackage`` with the personalization data applied. You can then inspect or modify the result before signing.

The pass protobuf definitions ship in this package's `Protobufs/` directory.
