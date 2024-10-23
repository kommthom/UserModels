//
//  LocationModel.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Vapor
import Fluent
import UserDTOs

public final class LocationModel: Model, @unchecked Sendable {
    public static let schema = "locations"
    
    @ID(key: .id)
    public var id: UUID?

    @Field(key: "name")
    public var name: String
    
    @Field(key: "identifier")
    public var identifier: String
    
    @Field(key: "timezone")
    public var timeZone: String
    
    @Children(for: \.$location)
    public var users: [UserModel]
    
    @Parent(key: "country_id")
    public var country: CountryModel
    
    public init() {}
    
    public init(id: UUID? = nil, countryId: CountryModel.IDValue, name: String, identifier: String, timeZone: String) {
        self.id = id
        self.$country.id = countryId
        self.name = name
        self.identifier = identifier
        self.timeZone = timeZone
    }
    
    public convenience init(with dto: LocationDTO) {
		self.init(id: dto.id?.rawValue, countryId: dto.countryId.rawValue, name: dto.name.rawValue, identifier: dto.identifier.rawValue, timeZone: dto.timeZone)
    }
}

extension LocationDTO {
    public init(with model: LocationModel, localization: @escaping @Sendable (_ key: String) -> String) {
        self.init(
			id: LocationDTO.LocationId(model.id!),
			name: LocationDTO.Name(model.name),
			identifier: LocationDTO.Identifier(model.identifier),
			timeZone: model.timeZone,
			countryId: CountryDTO.CountryId(model.$country.id)
		)
    }
}

extension LocationsDTO {
    public init(one: LocationModel, localization: @escaping @Sendable(_ key: String) -> String) {
		self.init(locations: [LocationDTO(with: one, localization: localization)])
    }

    public init(many: [LocationModel], localization: @escaping @Sendable (_ key: String) -> String) {
		self.init(locations: many.compactMap { LocationDTO(with: $0, localization: localization) })
    }
}
