//
//  CreateCountry.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import UserDTOs

public struct CreateCountry: AsyncMigration {
    public init() { }
    public func prepare(on database: Database) async throws {
		try await database.schema("countries").ignoreExisting()
            .id()
            .field("description", .string, .required)
            .field("identifier", .string, .required)
            .field("locale_id", .uuid, .references("locales", "id", onDelete: .cascade))
            .unique(on: "identifier", name: "altkey")
            .create()
    }
    
    public func revert(on database: Database) async throws {
		try await database.schema("countries").delete()
    }
}
