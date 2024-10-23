//
//  DatabaseLocaleRepository.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import UserDTOs

public struct DatabaseLocaleRepository: LocaleRepositoryProtocol, DatabaseRepositoryProtocol, Sendable {
    public let database: Database
    private let logger = Logger(label: "reminders.backend.countries")
    
    public func create(_ locale: LocaleModel) async throws {
        logger.info("Create Locale: \(locale.$name)")
		do {
			try await locale
				.create(on: database)
		} catch let error {
			if let dbError = error as? DatabaseError, dbError.isConstraintFailure {
				logger.error("Create Locale: duplicate key -> \(locale.$name)")
				throw LocaleRepositoryError.unableToCreateNewRecord
			}
			logger.error("Create Locale: error -> \(error.localizedDescription)")
			throw error
		}
		for country in locale.countries {
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
		try await LocaleModel
            .query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    public func all() async throws -> [LocaleModel] {
		try await LocaleModel
            .query(on: database)
            .all()
    }
    
    public func find(id: UUID?) async throws -> LocaleModel? {
		try await LocaleModel
            .find(id, on: database)
    }
    
	public func find(identifier: LocaleIdentifier) async throws -> LocaleModel? {
		try await LocaleModel
            .query(on: database)
            .filter(\.$identifier == identifier)
            .first()
    }
    
	public func find(name: String) async throws -> LocaleModel? {
		try await LocaleModel
            .query(on: database)
			.filter(\.$name == name)
            .first()
    }
    
    public func set(_ locale: LocaleModel) async throws {
		try await LocaleModel
            .query(on: database)
            .filter(\.$id == locale.id!)
            .set(\.$description, to: locale.description)
            .set(\.$identifier, to: locale.identifier)
            .set(\.$language.$id, to: locale.language.id!)
            .update()
    }
    
    public func set<Field>(_ field: KeyPath<LocaleModel, Field>, to value: Field.Value, for localeID: UUID) async throws
        where Field: QueryableProperty, Field.Model == LocaleModel {
		try await LocaleModel
            .query(on: database)
            .filter(\.$id == localeID)
            .set(field, to: value)
            .update()
    }
    
    public func count() async throws -> Int {
		try await LocaleModel
            .query(on: database)
            .count()
    }
    
    public init(database: Database) {
        self.database = database
    }
}

extension Application.Repositories {
    public var locales: LocaleRepositoryProtocol {
        guard let storage = storage.makeLocaleRepository else {
            fatalError("LocaleRepository not configured, use: app.localeRepository.use()")
        }
        
        return storage(app)
    }
    
    public func use(_ make: @escaping @Sendable (Application) -> (LocaleRepositoryProtocol)) {
        storage.makeLocaleRepository = make
    }
}

