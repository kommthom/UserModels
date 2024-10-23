//
//  SettingModel.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 30.01.24.
//

import Vapor
import Fluent
import UserDTOs

public final class SettingModel: Model, @unchecked Sendable {
    public static let schema = "settings"

    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "sortorder")
    public var sortOrder: Int
    
    @Enum(key: "scope")
    public var scope: ScopeType
    
    @Field(key: "name")
    public var name: String
    
    @Field(key: "description")
    public var description: String
    
    @OptionalField(key: "image")
    public var image: String?
    
    @Enum(key: "valuetype")
    public var valueType: SettingValueType
    
    @OptionalField(key: "boolvalue")
    public var boolValue: Bool?
    
    @OptionalField(key: "intvalue")
    public var intValue: Int?
    
    @OptionalField(key: "stringvalue")
    public var stringValue: String?
    
    @OptionalField(key: "idvalue")
    public var idValue: UUID?
    
    @OptionalField(key: "jsonvalue")
    public var jsonValue: String?
    
    @Timestamp(key: "deleted_at", on: .delete)
    public var deletedAt: Date?
    
    @Parent(key: "user_id")
    public var user: UserModel
    
    public init() {}
    
    public init(id: UUID? = nil, sortOrder: Int, scope: ScopeType, name: String, description: String, image: String? = nil, valueType: SettingValueType, boolValue: Bool? = nil, intValue: Int? = nil, stringValue: String? = nil, idValue: UUID? = nil, jsonValue: String? = nil, userId: UserModel.IDValue) {
        self.id = id
        self.sortOrder = sortOrder
        self.scope = scope
        self.name = name
        self.description = description
        self.image = image
        self.valueType = valueType
        self.boolValue = boolValue
        self.intValue = intValue
        self.stringValue = stringValue
        self.idValue = idValue
        self.jsonValue = jsonValue
        self.$user.id = userId
    }
    
    public convenience init(with dto: SettingDTO, for userId: UUID) {
        self.init(
			id: dto.id?.rawValue,
            sortOrder: dto.sortOrder,
            scope: dto.scope,
            name: dto.name,
			description: dto.description.rawValue,
            image: dto.image,
            valueType: dto.valueType,
            boolValue: dto.boolValue,
            intValue: dto.intValue,
            stringValue: dto.stringValue,
            idValue: dto.idValue,
            jsonValue: dto.jsonValue,
            userId: userId
        )
    }
}

extension SettingDTO {
    public init(with model: SettingModel, localization: @escaping @Sendable (_ key: String) -> String) {
		self.init(
			id: SettingDTO.SettingId(model.id!),
			sortOrder: model.sortOrder,
			scope: model.scope,
			name: model.name,
			description: SettingDTO.Description(rawValue: model.description),
			image: model.image,
			valueType: model.valueType,
			boolValue: model.boolValue,
			intValue: model.intValue,
			stringValue: model.stringValue,
			idValue: model.idValue,
			jsonValue: model.jsonValue,
			localization: localization
		)
    }
}

extension SettingsDTO {
    /// Create SettingsContext with only one setting from a model: not used
    public init(one: SettingModel, localization: @escaping @Sendable(_ key: String) -> String) {
		self.init(settings: [SettingDTO(with: one, localization: localization)])
    }

    /// Create SettingsContext with many settings from a model
    public init(many: [SettingModel], localization: @escaping @Sendable (_ key: String) -> String) {
		self.init(settings: many.compactMap { SettingDTO(with: $0, localization: localization) })
    }
}
