//
//  CreateLocale.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import UserDTOs

public struct CreateLocale: AsyncMigration {
    public init() { }
    public func prepare(on database: Database) async throws {
		let localeIdentifier = try await database.createEnum("localeidentifier", allCases: LocaleIdentifier.allCases.compactMap { $0.description } )
		try await database.schema("locales").ignoreExisting()
			.id()
			.field("name", .string, .required)
			.field("identifier", localeIdentifier)
			.field("description", .string, .required)
			.field("language_id", .uuid, .references("languages", "id", onDelete: .cascade))
			.unique(on: "identifier", name: "altkey")
			.create()
    }
    
    public func revert(on database: Database) async throws {
		try await database.schema("locales").delete()
    }
}
