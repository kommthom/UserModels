//
//  CountryModel.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Vapor
import Fluent
import UserDTOs

public final class CountryModel: Model, @unchecked Sendable {
    public static let schema = "countries"
    
    @ID(key: .id)
    public var id: UUID?

    @Field(key: "name")
    public var name: String
    
    @Field(key: "identifier")
    public var identifier: String
    
    @Children(for: \.$country)
    public var locations: [LocationModel]
    
	@Field(key: "location_id")
	public var defaultLocationId: LocationModel.IDValue
	
    @Siblings(through: CountryLocale.self, from: \.$country, to: \.$locale)
    public var locales: [LocaleModel]
    
    @Field(key: "locale_id")
    public var defaultLocaleId: LocaleModel.IDValue
    
    public init() {}
    
    public init(id: UUID? = nil, name: String, identifier: String, defaultLocaleId: LocaleModel.IDValue) {
        self.id = id
        self.defaultLocaleId = defaultLocaleId
        self.name = name
        self.identifier = identifier
    }
    
    public convenience init(with dto: CountryDTO) {
		self.init(id: dto.id?.rawValue, name: dto.name.rawValue, identifier: dto.identifier.rawValue, defaultLocaleId: dto.defaultLocale.id!.rawValue)
    }
}

extension CountryDTO {
    public init(with model: CountryModel, localization: @escaping @Sendable (String) -> String) {
        self.init(
			id: CountryDTO.CountryId(model.id!),
			name: CountryDTO.Name(model.name),
			identifier: CountryDTO.Identifier(model.identifier),
            locales: LocalesDTO(many: model.locales, localization: localization),
			defaultLocale: LocaleDTO(with: model.locales.first(where: { $0.id == model.defaultLocaleId } )!, localization: localization ),
			locations: LocationsDTO(many: model.locations, localization: localization),
			defaultLocation: LocationDTO(with: model.locations.first(where: { $0.id == model.defaultLocationId } )!, localization: localization ),
            localization: localization
        )
    }
}

extension CountriesDTO {
    public init(one: CountryModel, localization: @escaping @Sendable (String) -> String) {
		self.init(countries: [CountryDTO(with: one, localization: localization)])
    }

	public init(many: [CountryModel], localization: @escaping @Sendable (String) -> String) {
		self.init(countries: many.compactMap { CountryDTO(with: $0, localization: localization) })
    }
}

