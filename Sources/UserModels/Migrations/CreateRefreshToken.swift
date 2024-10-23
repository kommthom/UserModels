//
//  CreateRefreshToken.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Fluent

public struct CreateRefreshToken: AsyncMigration {
    public  init() { }
    public func prepare(on database: Database) async throws {
		try await database.schema("user_refresh_tokens").ignoreExisting()
            .id()
            .field("token", .string)
            .field("user_id", .uuid, .references("users", "id", onDelete: .cascade))
            .field("expires_at", .datetime)
            .field("issued_at", .datetime)
            .unique(on: "token")
            .unique(on: "user_id")
            .create()
    }
    
    public func revert(on database: Database) async throws {
		try await database.schema("user_refresh_tokens").delete()
    }
}
