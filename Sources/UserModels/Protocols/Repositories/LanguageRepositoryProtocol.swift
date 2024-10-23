//
//  LanguageRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import UserDTOs

public protocol LanguageRepositoryProtocol: DBRepositoryProtocol {
    func create(_ languagee: LanguageModel) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [LanguageModel]
    func find(id: UUID?) async throws -> LanguageModel?
    func find(identifier: LanguageIdentifier) async throws -> LanguageModel?
    func find(name: String) async throws -> LanguageModel?
    func set(_ language: LanguageModel) async throws
    func set<Field>(_ field: KeyPath<LanguageModel, Field>, to value: Field.Value, for languageID: UUID) async throws
        where Field: QueryableProperty, Field.Model == LanguageModel
    func count() async throws -> Int
}
