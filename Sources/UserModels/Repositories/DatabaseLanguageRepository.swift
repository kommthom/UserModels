//
//  DatabaseLanguageRepository.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import UserDTOs

public struct DatabaseLanguageRepository: LanguageRepositoryProtocol, DatabaseRepositoryProtocol, Sendable {
    public let database: Database
    private let logger = Logger(label: "reminders.backend.countries")
    
    public func create(_ language: LanguageModel) async throws {
        logger.info("Create Language: \(language.$name)")
		do {
			try await language
				.create(on: database)
		} catch let error {
			if let dbError = error as? DatabaseError, dbError.isConstraintFailure {
				logger.error("Create Language: duplicate key -> \(language.$name)")
				throw LanguageRepositoryError.unableToCreateNewRecord
			}
			logger.error("Create Language: error -> \(error.localizedDescription)")
			throw error
		}
    }
    
    public func delete(id: UUID) async throws {
		try await LanguageModel
            .query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    public func all() async throws -> [LanguageModel] {
		try await LanguageModel
            .query(on: database)
            .all()
    }
    
    public func find(id: UUID?) async throws -> LanguageModel? {
		try await LanguageModel
            .find(id, on: database)
    }
    
    public func find(name: String) async throws -> LanguageModel? {
		try await LanguageModel
            .query(on: database)
            .filter(\.$name == name)
            .first()
    }
    
    public func find(identifier: LanguageIdentifier) async throws -> LanguageModel? {
		try await LanguageModel
            .query(on: database)
            .filter(\.$identifier == identifier)
            .first()
    }
    
    public func set(_ language: LanguageModel) async throws {
		try await LanguageModel
            .query(on: database)
            .filter(\.$id == language.id!)
            .set(\.$identifier, to: language.identifier)
            .set(\.$name, to: language.name)
            .update()
    }
    
    public func set<Field>(_ field: KeyPath<LanguageModel, Field>, to value: Field.Value, for languageID: UUID) async throws
        where Field: QueryableProperty, Field.Model == LanguageModel
    {
		try await LanguageModel
            .query(on: database)
            .filter(\.$id == languageID)
            .set(field, to: value)
            .update()
    }
    
    public func count() async throws -> Int {
		try await LanguageModel
            .query(on: database)
            .count()
    }
    
    public init(database: Database) {
        self.database = database
    }
}

extension Application.Repositories {
    public var languages: LanguageRepositoryProtocol {
        guard let storage = storage.makeLanguageRepository else {
            fatalError("LanguageRepository not configured, use: app.languageRepository.use()")
        }
        
        return storage(app)
    }
    
    public func use(_ make: @escaping @Sendable (Application) -> (LanguageRepositoryProtocol)) {
        storage.makeLanguageRepository = make
    }
}

