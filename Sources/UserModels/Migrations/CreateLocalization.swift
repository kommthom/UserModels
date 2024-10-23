//
//  CreateLocalization.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Foundation
import Fluent
import UserDTOs

public struct CreateLocalization: AsyncMigration {
    public init() { }
    public func prepare(on database: Database) async throws {
		try await database.schema("localizations").ignoreExisting()
			.id()
			.field("modeltype", .string, .required)
			.field("identifier", .string, .required)
			.field("enum", .int)
			.field("key", .string, .required)
			.field("value", .string)
			.field("pluralized", .dictionary(of: .string))
			.field("deleted_at", .datetime)
			.unique(on: "identifier", "enum", "key", name: "altkey")
			.create()
    }
    
    public func revert(on database: Database)  async throws {
		try await database.schema("localizations").delete()
    }
}
