//
//  CreateLocation.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import UserDTOs

public struct CreateLocation: AsyncMigration {
    public init() { }
    public func prepare(on database: Database)  async throws {
		try await database.schema("locations").ignoreExisting()
            .id()
            .field("description", .string, .required)
            .field("identifier", .string, .required)
            .field("timezone", .string, .required)
            .field("country_id", .uuid, .references("countries", "id", onDelete: .cascade))
            .unique(on: "identifier", name: "altkey")
            .create()
    }
    
    public func revert(on database: Database) async throws {
		try await database.schema("locations").delete()
    }
}
