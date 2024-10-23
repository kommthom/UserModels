//
//  CreateUser.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Fluent
import UserDTOs

public struct CreateUser: AsyncMigration {
    public init() { }
    public func prepare(on database: Database) async throws {
		try await database.schema("users").ignoreExisting()
			.id()
			.field("full_name", .string, .required)
			.field("email", .string, .required)
			.field("image_url", .string)
			.field("password_hash", .string, .required)
			.field("is_admin", .bool, .required, .custom("DEFAULT FALSE"))
			.field("is_email_verified", .bool, .required, .custom("DEFAULT FALSE"))
			.field("locale_id", .uuid, .references("locales", "id"))
			.field("location_id", .uuid, .references("locations", "id"))
			.field("deleted_at", .datetime)
			.unique(on: "email", "deleted_at")
			.create()
    }
    
    public func revert(on database: Database) async throws {
		try await database.schema("users").delete()
    }
}
