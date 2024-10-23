//
//  CreateLanguage.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 16.05.24.
//

import Fluent
import UserDTOs

public struct CreateLanguage: AsyncMigration {
    public init() { }
    public func prepare(on database: Database) async throws {
		let languageIdentifier = try await database.createEnum("languageidentifier", allCases: LanguageIdentifier.allCases.compactMap { $0.description } )
        try await database.schema("languages").ignoreExisting()
			.id()
			.field("name", .string, .required)
			.field("identifier", languageIdentifier)
			.field("longname", .string, .required)
			.unique(on: "identifier", name: "altkey")
			.create()
    }
    
    public func revert(on database: Database)  async throws {
		try await database.schema("languages").delete()
    }
}
