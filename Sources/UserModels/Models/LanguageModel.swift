//
//  LanguageModel.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 15.05.24.
//

import Vapor
import Fluent
import UserDTOs

public final class LanguageModel: Model, @unchecked Sendable {
    public static let schema = "languages"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "name")
    public var name: String
    
    @Field(key: "identifier")
    public var identifier: LanguageIdentifier
    
    @Children(for: \.$language)
    public var locales: [LocaleModel]
    
    public init() {}
    
    public init(id: UUID? = nil, name: String, identifier: LanguageIdentifier) {
        self.id = id
        self.name = name
        self.identifier = identifier
    }
    
    public convenience init(with dto: LanguageDTO) {
		self.init(id: dto.id?.rawValue, name: dto.name.rawValue, identifier: dto.identifierEnum)
    }
}

extension LanguageDTO {
	public init(with model: LanguageModel, localization: @escaping @Sendable (String) -> String) {
		self.init(
			id: LanguageDTO.LanguageId(rawValue: model.id!),
			name: LanguageDTO.Name(model.name),
			identifier: LanguageDTO.Identifier(model.identifier.identifier),
			locales: LocalesDTO(
				many: model.locales,
				localization: localization),
			identifierEnum: model.identifier,
			localization: localization)
    }
}

extension LanguagesDTO {
	public init(one: LanguageModel, localization: @escaping @Sendable (String) -> String) {
		self.init(languages: [LanguageDTO(with: one, localization: localization)])
    }

	public init(many: [LanguageModel], localization: @escaping @Sendable (String) -> String) {
		self.init(languages: many.compactMap { LanguageDTO(with: $0, localization: localization) })
    }
}
