//
//  LocaleModel.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 15.05.24.
//

import Vapor
import Fluent
import UserDTOs

public final class LocaleModel: Model, @unchecked Sendable {
    public static let schema = "locales"
    
    @ID(key: .id)
    public var id: UUID?

    @Field(key: "name")
    public var name: String
    
    @Field(key: "identifier")
    public var identifier: LocaleIdentifier
    
    @Field(key: "description")
    public var description: String
    
	@Siblings(through: CountryLocale.self, from: \.$locale, to: \.$country)
    public var countries: [CountryModel]
    
    @Children(for: \.$locale)
    public var users: [UserModel]
    
    @Parent(key: "language_id")
    public var language: LanguageModel
    
    public init() {}
    
    public init(id: UUID? = nil, name: String, identifier: LocaleIdentifier, description: String, languageId: LanguageModel.IDValue) {
        self.id = id
        self.name = name
        self.identifier = identifier
        self.description = description
        self.$language.id = languageId
    }
    
    public convenience init(with dto: LocaleDTO) {
		self.init(id: dto.id?.rawValue, name: dto.name.rawValue, identifier: dto.identifierEnum, description: dto.description.rawValue, languageId: dto.languageId.rawValue)
    }
}

extension LocaleDTO {
	public init(with model: LocaleModel, localization: @escaping @Sendable (String) -> String) {
        self.init(
			id: LocaleDTO.LocaleId(rawValue: model.id!),
			name: LocaleDTO.Name(model.name),
			identifier: LocaleDTO.Identifier(model.identifier.identifier),
			description: LocaleDTO.Description(model.description),
			languageId: LanguageDTO.LanguageId(model.language.id!),
			identifierEnum: model.identifier,
			localization: localization)
    }
}

extension LocalesDTO {
    public init(one: LocaleModel, localization: @escaping @Sendable (String) -> String) {
		self.init(locales: [LocaleDTO(with: one, localization: localization)])
    }

    public init(many: [LocaleModel], localization: @escaping @Sendable (String) -> String) {
		self.init(locales: many.compactMap { LocaleDTO(with: $0, localization: localization) })
    }
}
