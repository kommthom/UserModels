//
//  LocalizationRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 14.05.24.
//

import Vapor
import Fluent
import UserDTOs
//import Lingo

public protocol LocalizationRepositoryProtocol: DBRepositoryProtocol {
    func create(_ localization: LocalizationModel) async throws -> Void
    func create(_ localizations: [LocalizationModel]) async throws -> Void
    func delete(id: UUID?, force: Bool) async throws -> Void
    func find(id: UUID?) async throws-> LocalizationModel?
    func find(userName: String, locale: String, key: String) async throws-> LocalizationModel?
//    func find(locale: String, key: KeyWord) async throws -> LocalizationModel?
    func find(locale: String, enumKey: Int) async throws-> LocalizationModel?
    func set(_  localization: LocalizationModel) async throws -> Void
    func set<Field>(_ field: KeyPath<LocalizationModel, Field>, to value: Field.Value, for localizationID: UUID) async throws -> Void
        where Field: QueryableProperty, Field.Model == LocalizationModel
    func allLocales() async throws -> [String]
	func allKeyWordLocales() async throws -> [String]
    func all() async throws -> [LocalizationModel]
    func all(locale: String) async throws -> [LocalizationModel]
    func allKeyWords() async throws -> [LocalizationModel]
}
