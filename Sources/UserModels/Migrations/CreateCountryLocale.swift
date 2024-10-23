//
//  CreateCountryLocale.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent

public struct CreateCountryLocale: AsyncMigration {
    public init() { }
    public func prepare(on database: Database) async throws {
		try await database.schema("countrylocales").ignoreExisting()
            .id()
            .field("country_id", .uuid, .required, .references("countries", "id", onDelete: .cascade))
            .field("locale_id", .uuid, .required, .references("locales", "id", onDelete: .cascade))
            .create()
    }
    
    public func revert(on database: Database) async throws {
		try await database.schema("countrylocales").delete()
    }
}
