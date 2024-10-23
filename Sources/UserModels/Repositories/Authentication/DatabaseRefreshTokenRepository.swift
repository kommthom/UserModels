//
//  DatabaseRefreshTokenRepository.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent

public struct DatabaseRefreshTokenRepository: RefreshTokenRepositoryProtocol, DatabaseRepositoryProtocol, Sendable {
    public let database: Database
    private let logger = Logger(label: "reminders.backend")
    
    public func create(_ token: RefreshToken) async throws {
        logger.info("Create new refresh token: \(token)")
		do {
			try await token
				.create(on: database)
		} catch let error {
			logger.error("Create new refresh token: error -> \(error.localizedDescription)")
			throw error
		}
    }
    
    public func find(id: UUID?) async throws -> RefreshToken? {
		try await RefreshToken.find(id, on: database)
    }
    
    public func find(token: String) async throws -> RefreshToken? {
		try await RefreshToken.query(on: database)
            .filter(\.$token == token)
            .first()
    }
    
    public func delete(_ token: RefreshToken) async throws {
		try await token.delete(on: database)
    }
    
    public func count() async throws -> Int {
		try await RefreshToken.query(on: database)
            .count()
    }
    
    public func delete(for userID: UUID) async throws {
		try await RefreshToken.query(on: database)
            .filter(\.$user.$id == userID)
            .delete()
    }
    
    public init(database: Database) {
        self.database = database
    }
}

extension Application.Repositories {
    public var refreshTokens: RefreshTokenRepositoryProtocol {
        guard let factory = storage.makeRefreshTokenRepository else {
            fatalError("RefreshToken repository not configured, use: app.repositories.use")
        }
        return factory(app)
    }
    
    public func use(_ make: @escaping @Sendable (Application) -> (RefreshTokenRepositoryProtocol)) {
        storage.makeRefreshTokenRepository = make
    }
}
