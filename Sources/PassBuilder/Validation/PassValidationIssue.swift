//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

/// An issue found when validating a pass.
public struct PassValidationIssue: Identifiable, Sendable, Equatable {
    #if os(macOS) || os(iOS)
    public typealias Message = String.LocalizationValue
    #else
    public typealias Message = String
    #endif

    /// The severity of the issue.
    public enum Severity: Int, Sendable {
        // A blocking issue with the pass. This must be fixed before sign & build can be permitted.
        case error = 1
        // A non-blocking recommendation. Sign & build is still permitted.
        case warning = 2
    }

    /// A unique identifier for the issue.
    public var id = UUID()

    /// The severity of the issue.
    public var severity: Severity

    /// A string that describes the type of issue that occurred.
    public var issueType: String?

    /// The domain in which the error occurred.
    public var domain: PassPropertyDomain

    /// The unique identifier of the item in the domain.
    /// For example, when a `PassSeat` has an error, `domainItemID` is the unique identifier of the seat.
    public var domainItemID: Pass.ItemID?

    /// The specific property in the domain where the issue occurred.
    /// For example, `venueName` of `Pass.Semantics`.
    public var property: String?

    /// A user-friendly message that explains the issue and how to correct it.
    public var message: String
}

extension PassValidationIssue: CustomDebugStringConvertible {
    public var debugDescription: String {
        "PassValidationIssue { severity: \(severity), message: \(message) }"
    }
}

extension PassValidationIssue: Comparable {
    public static func < (lhs: PassValidationIssue, rhs: PassValidationIssue) -> Bool {
        lhs.severity.rawValue < rhs.severity.rawValue &&
        lhs.id < rhs.id
    }
}

extension PassValidationIssue {
    // Using Bundle requires importing full Foundation on Linux.
    // Only compile it in for Apple platforms.
#if os(macOS) || os(iOS)
    public init(
        id: UUID = UUID(),
        severity: Severity,
        issueType: String? = nil,
        domain: PassPropertyDomain,
        fileName: String,
        message: Message,
        bundle: Bundle? = nil
    ) {
        self.id = id
        self.severity = severity
        self.issueType = issueType
        self.domain = domain
        self.domainItemID = nil
        self.property = fileName
        self.message = String(localized: message, bundle: bundle ?? .module)
    }
    public init<Value>(
        id: UUID = UUID(),
        severity: Severity,
        issueType: String? = nil,
        domain: PassPropertyDomain,
        domainItemID: Pass.ItemID? = nil,
        property: PassProperty<Value>? = nil,
        message: Message,
        bundle: Bundle? = nil
    ) {
        self.id = id
        self.severity = severity
        self.issueType = issueType
        self.domain = domain
        self.domainItemID = domainItemID
        self.property = property?.name
        self.message = String(localized: message, bundle: bundle ?? .module)
    }
#else
    public init(
        id: UUID = UUID(),
        severity: Severity,
        issueType: String? = nil,
        domain: PassPropertyDomain,
        fileName: String,
        message: Message,
    ) {
        self.id = id
        self.severity = severity
        self.issueType = issueType
        self.domain = domain
        self.domainItemID = nil
        self.property = fileName
        self.message = message
    }
    public init<Value>(
        id: UUID = UUID(),
        severity: Severity,
        issueType: String? = nil,
        domain: PassPropertyDomain,
        domainItemID: Pass.ItemID? = nil,
        property: PassProperty<Value>? = nil,
        message: Message
    ) {
        self.id = id
        self.severity = severity
        self.issueType = issueType
        self.domain = domain
        self.domainItemID = domainItemID
        self.property = property?.name
        self.message = message
    }
#endif
}
