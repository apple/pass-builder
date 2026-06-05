# Validating passes

Check a pass package for errors and warnings before signing and distributing it.

## Overview

Use ``PassValidator`` to check your pass package for common issues before you sign and distribute it. The validator runs a series of plugins that inspect different aspects of your pass, from missing images and incorrect field formatting to incomplete semantic data for event tickets and boarding passes.

A validation check returns a ``PassValidationResult`` containing any issues it finds. Each ``PassValidationIssue`` has a severity level. Errors block signing and you must fix them. Warnings highlight recommendations you can address.

## Validate a pass package

Create a ``PassValidator`` instance and call ``PassValidator/validate(_:)`` with your pass package:

```swift
let validator = PassValidator()
let result = validator.validate(package)

for issue in result.issues {
    print("\(issue.severity): \(issue.message)")
}
```

An empty `issues` array means the pass is ready to sign.

## Create a custom validation plugin

To add your own validation rules, create a type that conforms to the ``PassValidationPlugin`` protocol. A plugin defines two methods: ``PassValidationPlugin/shouldValidatePackage(_:)`` determines whether the plugin applies to a given package, and ``PassValidationPlugin/validatePackage(_:)`` returns any issues it finds.

```swift
struct MyCustomValidator: PassValidationPlugin {
    func shouldValidatePackage(_ package: PassPackage) -> Bool {
        // Return true if this plugin applies to the package.
        return true
    }

    @PassValidationBuilder
    func validatePackage(_ package: PassPackage) -> [PassValidationIssue] {
        if package.pass.description.isEmpty {
            PassValidationIssue(
                severity: .warning,
                domain: .identitySigning,
                message: "The pass description is empty."
            )
        }
    }
}
```

The ``PassValidationBuilder`` result builder lets you write validation logic using standard Swift control flow. `if` statements, `for` loops, and optional checks all work as expected.

Register your plugin with a ``PassValidator`` instance:

```swift
var validator = PassValidator()
validator.registerPlugin(MyCustomValidator())
let result = validator.validate(package)
```

Your custom plugin runs alongside the built-in plugins, and its issues appear in the same ``PassValidationResult``.
