//
//  DatabaseCountryRepository.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import UserDTOs

public struct DatabaseCountryRepository: CountryRepositoryProtocol, DatabaseRepositoryProtocol, Sendable {
    public let database: Database
    private let logger = Logger(label: "reminders.backend.countries")
    
    public func create(_ country: CountryModel) async throws {
		logger.info("Create Country: \(country.$name)")
		do {
			try await country
				.create(on: database)
		} catch let error {
			if let dbError = error as? DatabaseError, dbError.isConstraintFailure {
				logger.error("Create Country: duplicate key -> \(country.$name)")
				throw CountryRepositoryError.unableToCreateNewRecord
			}
			logger.error("Create Country: error -> \(error.localizedDescription)")
			throw error
		}
		for locale in country.locales {
            try await createLink(countryId: country.id, localeId: locale.id!)
		}
    }
    
    public func createLink(countryId: UUID?, localeId: UUID) async throws {
        if let _ = countryId {
            try await CountryLocale(id: UUID(), countryId: countryId!, localeId: localeId)
                .create(on: database)
        }
    }
    
    public func delete(id: UUID) async throws {
		try await CountryModel
            .query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    public func all() async throws -> [CountryModel] {
		try await CountryModel
            .query(on: database)
            .with(\.$locales)
            .with(\.$locations)
            .all()
    }
    
    public func find(id: UUID?) async throws -> CountryModel? {
		try await CountryModel
            .find(id, on: database)
    }
    
    public func find(identifier: String) async throws -> CountryModel? {
		try await CountryModel
            .query(on: database)
            .filter(\.$identifier == identifier)
            .first()
    }
    
    public func set(_ country: CountryModel) async throws {
		try await CountryModel
            .query(on: database)
            .filter(\.$id == country.id!)
			.set(\.$name, to: country.name)
            .set(\.$identifier, to: country.identifier)
            .update()
    }
    
    public func set<Field>(_ field: KeyPath<CountryModel, Field>, to value: Field.Value, for countryID: UUID) async throws
        where Field: QueryableProperty, Field.Model == CountryModel
    {
	try await CountryModel
            .query(on: database)
            .filter(\.$id == countryID)
            .set(field, to: value)
            .update()
    }
    
    public func count(userId: UUID?) async throws -> Int {
		try await CountryModel
            .query(on: database)
            .count()
    }
    
    public init(database: Database) {
        self.database = database
    }
}

extension Application.Repositories {
    public var countries: CountryRepositoryProtocol {
        guard let storage = storage.makeCountryRepository else {
            fatalError("CountryRepository not configured, use: app.countryRepository.use()")
        }
        
        return storage(app)
    }
    
    public func use(_ make: @escaping @Sendable (Application) -> (CountryRepositoryProtocol)) {
        storage.makeCountryRepository = make
    }
}
