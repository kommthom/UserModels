//
//  CreateEmailToken.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Fluent

public struct CreateEmailToken: AsyncMigration {
	public init() { }
		
	public func prepare(on database: any FluentKit.Database) async throws {
    //public func prepare(on database: Database) -> EventLoopFuture<Void> {
        try await database.schema("user_email_tokens").ignoreExisting()
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("token", .string, .required)
            .field("expires_at", .datetime, .required)
            .unique(on: "user_id")
            .unique(on: "token")
            .create()
    }
    
	public func revert(on database: any FluentKit.Database) async throws {
    //public func revert(on database: Database) -> EventLoopFuture<Void> {
        try await database.schema("user_email_tokens").delete()
    }
}
