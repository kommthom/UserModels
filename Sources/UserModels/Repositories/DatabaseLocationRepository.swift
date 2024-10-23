//
//  DatabaseLocationRepository.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent

public struct DatabaseLocationRepository: LocationRepositoryProtocol, DatabaseRepositoryProtocol, Sendable {
    public let database: Database
    private let logger = Logger(label: "reminders.backend.locations")
    
    public func create(_ location: LocationModel) async throws {
        logger.info("Create Location: \(location.$name)")
		do {
			try await location
				.create(on: database)
		} catch let error {
			if let dbError = error as? DatabaseError, dbError.isConstraintFailure {
				logger.error("Create Location: duplicate key -> \(location.$identifier)")
				throw LocationRepositoryError.unableToCreateNewRecord
			}
			logger.error("Create Location: error -> \(error.localizedDescription)")
			throw error
		}
    }
    
    public func delete(id: UUID) async throws {
		try await LocationModel
            .query(on: database)
            .filter(\.$id == id)
            .delete(force: true)
    }
    
    public func all() async throws -> [LocationModel] {
		try await LocationModel
            .query(on: database)
            .all()
    }
    
    public func find(id: UUID) async throws -> LocationModel? {
		try await LocationModel
            .find(id, on: database)
    }
    
    public func find(countryId: UUID) async throws -> [LocationModel] {
		try await LocationModel
            .query(on: database)
            .filter(\.$country.$id == countryId)
            .all()
    }
    
    public func find(identifier: String) async throws -> LocationModel? {
		try await LocationModel
            .query(on: database)
            .filter(\.$identifier == identifier)
            .first()
    }
    
    public func set(_ location: LocationModel) async throws {
		try await LocationModel
            .query(on: database)
            .filter(\.$id == location.id!)
            .set(\.$name, to: location.name)
            .set(\.$identifier, to: location.identifier)
            .set(\.$timeZone, to: location.timeZone)
            .update()
    }
    
    public func set<Field>(_ field: KeyPath<LocationModel, Field>, to value: Field.Value, for locationID: UUID) async throws
        where Field: QueryableProperty, Field.Model == LocationModel {
		try await LocationModel
            .query(on: database)
            .filter(\.$id == locationID)
            .set(field, to: value)
            .update()
    }
    
    public func count() async throws -> Int {
		try await LocationModel
            .query(on: database)
            .count()
    }
    
    public init(database: Database) {
        self.database = database
    }
}

extension Application.Repositories {
    public var locations: LocationRepositoryProtocol {
        guard let storage = storage.makeLocationRepository else {
            fatalError("LocationRepository not configured, use: app.locationRepository.use()")
        }
        
        return storage(app)
    }
    
    public func use(_ make: @escaping @Sendable (Application) -> (LocationRepositoryProtocol)) {
        storage.makeLocationRepository = make
    }
}

