//
// This source file is part of the Pass Builder open source project
//
// Copyright (c) 2026 Apple Inc. and the Pass Builder project authors
// Licensed under Apache License v2.0.
//
// See LICENSE.txt for license information
//

import PlatformFoundation

extension Pass.Fields {
    mutating func extractMessage(from protobuf: PBPassFields) throws {
        if protobuf.hasHeaderFields {
            headerFields = try protobuf.headerFields.fields.map { try Pass.FieldContent(protobuf: $0) }
        } else {
            try updateFields(&headerFields, withMessage: protobuf)
        }

        if protobuf.hasPrimaryFields {
            primaryFields = try protobuf.primaryFields.fields.map { try Pass.FieldContent(protobuf: $0) }
        } else {
            try updateFields(&primaryFields, withMessage: protobuf)
        }

        if protobuf.hasSecondaryFields {
            secondaryFields = try protobuf.secondaryFields.fields.map { try Pass.FieldContent(protobuf: $0) }
        } else {
            try updateFields(&secondaryFields, withMessage: protobuf)
        }

        if protobuf.hasAuxiliaryFields {
            auxiliaryFields = try protobuf.auxiliaryFields.fields.map { try Pass.FieldContent(protobuf: $0) }
        } else {
            try updateFields(&auxiliaryFields, withMessage: protobuf)
        }

        if protobuf.hasBackFields {
            backFields = try protobuf.backFields.fields.map { try Pass.FieldContent(protobuf: $0) }
        } else {
            try updateFields(&backFields, withMessage: protobuf)
        }

        if protobuf.hasAdditionalInfoFields {
            additionalInfoFields = try protobuf.additionalInfoFields.fields.map { try Pass.FieldContent(protobuf: $0) }
        } else {
            try updateFields(&additionalInfoFields, withMessage: protobuf)
        }

        if protobuf.hasFooterFields {
            footerFields = try protobuf.footerFields.fields.map { try Pass.FieldContent(protobuf: $0) }
        } else {
            try updateFields(&footerFields, withMessage: protobuf)
        }

        if protobuf.hasTransitType {
            transitType = try Pass.TransitType(protobuf: protobuf.transitType)
        }
    }

    func updateFields(_ fields: inout [Pass.FieldContent]?, withMessage protobuf: PBPassFields) throws {
        let valueForKey = protobuf.fieldCustomization.valueForKey
        let visibilityForKey = protobuf.fieldCustomization.visibilityForKey

        let updatedFields = fields?.compactMap { field -> Pass.FieldContent? in
            // If the field has been specified as hidden, filter it out.
            let isFieldVisible = visibilityForKey[field.key] ?? true
            if !isFieldVisible {
                return nil
            }

            guard let value = valueForKey[field.key] else {
                return field
            }

            var field = field
            field.decodeValue(from: value)
            return field
        }

        fields = updatedFields
    }
}

extension Pass.TransitType {
    init(protobuf: PBPassTransitType) throws {
        switch protobuf {
        case .transitTypeAir: self = .air
        case .transitTypeBoat: self = .boat
        case .transitTypeBus: self = .bus
        case .transitTypeTrain: self = .train
        case .transitTypeGeneric: self = .generic
        default: throw ProtobufError.invalidValue(message: "PassTransitType type is not recognized.")
        }
    }
}
