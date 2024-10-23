//
//  DatabaseLocalizationRepository.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 14.05.24.
//

import Vapor
import Fluent
import UserDTOs
//import Lingo

public struct DatabaseLocalizationRepository: LocalizationRepositoryProtocol, DatabaseRepositoryProtocol, Sendable {
    public let database: Database
    private let logger = Logger(label: "reminders.backend.localization")
    
    public init(database: Database) {
        self.database = database
    }
    
    public func create(_ localization: LocalizationModel) async throws -> Void {
		do {
			try await localization
				.create(on: database)
		} catch let error {
			if let dbError = error as? DatabaseError, dbError.isConstraintFailure {
				logger.error("Create Localization: duplicate key -> \(localization.$key)")
				throw LocalizationRepositoryError.unableToCreateNewRecord
			}
			logger.error("Create Localization: error -> \(error.localizedDescription)")
			throw error
		}
    }
    
    public func create(_ localizations: [LocalizationModel]) async throws -> Void {
		try await localizations
			.create(on: database)
    }
    
    public func delete(id: UUID?, force: Bool) async throws -> Void {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$id == id!)
            .delete()
    }
    
    public func find(id: UUID?) async throws -> LocalizationModel? {
		try await LocalizationModel
            .find(id, on: database)
    }
    
    public func find(userName: String, locale: String, key: String) async throws -> LocalizationModel? {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$key == key)
			.filter(\.$identifier ~~ [userName, locale])
            .first()
    }
    
//    public func find(locale: String, key: KeyWord) async throws -> LocalizationModel? {
//        try await LocalizationModel
//            .query(on: database)
//			.filter(\.$enumKey == key.numericKey)
//			.filter(\.$identifier == locale)
//            .first()
//    }
    
    public func find(locale: String, enumKey: Int) async throws -> LocalizationModel? {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$enumKey == enumKey)
			.filter(\.$identifier == locale)
            .first()
    }
    
    public func set(_ localization: LocalizationModel) async throws -> Void {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$id == localization.id!)
            .set(\.$key, to: localization.key)
            .set(\.$value, to: localization.value)
            .update()
    }
    
    public func set<Field>(_ field: KeyPath<LocalizationModel, Field>, to value: Field.Value, for localizationID: UUID) async throws -> Void where Field : QueryableProperty, Field.Model == LocalizationModel {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$id == localizationID)
            .set(field, to: value)
            .update()
    }

	public func allLocales() async throws -> [String] {
		try await LocalizationModel
			.query(on: database)
			.filter(\.$enumKey == nil)
			.unique()
			.all(\.$identifier)
			.map { $0 }
	}
	
	public func allKeyWordLocales() async throws -> [String] {
		try await LocalizationModel
			.query(on: database)
			.filter(\.$enumKey != nil)
			.unique()
			.all(\.$identifier)
			.map { $0 }
	}
    
    public func all() async throws -> [LocalizationModel] {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$enumKey == nil)
            .all()
    }
    
    public func all(locale: String) async throws -> [LocalizationModel] {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$enumKey == nil)
			.filter(\.$identifier == locale)
            .all()
    }
    
    public func allKeyWords() async throws -> [LocalizationModel] {
		try await LocalizationModel
            .query(on: database)
            .filter(\.$enumKey != nil)
            .all()
    }
}

extension Application.Repositories {
    public var localizations: LocalizationRepositoryProtocol {
        guard let storage = storage.makeLocalizationRepository else {
            fatalError("LocalizationRepository not configured, use: app.localizationRepository.use()")
        }
        
        return storage(app)
    }
    
	public func use(_ make: @escaping @Sendable (Application) -> (LocalizationRepositoryProtocol)) {
        storage.makeLocalizationRepository = make
    }
}
