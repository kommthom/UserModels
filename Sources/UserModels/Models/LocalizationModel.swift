//
//  LocalizationModel.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Vapor
import Fluent
import UserDTOs
import DateExtensions

public final class LocalizationModel: Model, @unchecked Sendable {
    public static let schema = "localizations"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "modeltype")
    public var modelType: String //ModelType
    
    @Field(key: "identifier")
    public var identifier: String
    
    @OptionalField(key: "enum") // reference keyword
    public var enumKey: Int?
    
    @Field(key: "key")
    public var key: String
    
    @OptionalField(key: "value")
    public var value: String?
    
    @OptionalField(key: "pluralized")
    public var pluralized: [String: String]?

    @Timestamp(key: "deleted_at", on: .delete)
    public var deletedAt: Date?
    
    public init() {}
    
	public init(id: UUID? = nil, modelType: ModelType.RawValue, identifier: String, enumKey: Int?, key: String, value: String?, pluralized: [String: String]? = nil) {
        self.id = id
        self.modelType = modelType
        self.identifier = identifier
        self.enumKey = enumKey
        self.key = key
        self.value = value
        self.pluralized = pluralized
    }
    
    public convenience init(with dto: LocalizationDTO) {
        self.init(
			id: UUID(),
			modelType: dto.modelType.rawValue,
			identifier:  dto.identifier.rawValue,
			enumKey: dto.enumKey?.rawValue,
			key: dto.key.rawValue,
			value: dto.value,
			pluralized: dto.pluralized
		)
    }
}

extension LocalizationDTO {
	public init(with model: LocalizationModel) {
		self.init(
			id: LocalizationDTO.LocalizationId(model.id!),
			modelType: LocalizationDTO.ModelType(model.modelType),
			identifier: LocalizationDTO.Identifier(rawValue: model.identifier),
			enumKey: model.enumKey == nil ? nil : LocalizationDTO.EnumKey(model.enumKey!), // KeyWord(rawValue: model.enumKey!),
			key: LocalizationDTO.Key(rawValue: model.key),
			value: model.value,
			pluralized: model.pluralized
		)
	}
}

extension LocalizationsDTO {
	public init(one: LocalizationModel) {
		self.init(localizations: [LocalizationDTO(with: one)])
	}

	public init(many: [LocalizationModel]) {
		self.init(localizations: many.compactMap { LocalizationDTO(with: $0) })
	}
}
