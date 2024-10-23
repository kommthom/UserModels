//
//  LocaleRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import UserDTOs

public protocol LocaleRepositoryProtocol: DBRepositoryProtocol {
    func create(_ locale: LocaleModel) async throws
    func createLink(countryId: UUID?, localeId: UUID) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [LocaleModel]
    func find(id: UUID?) async throws -> LocaleModel?
    func find(identifier: LocaleIdentifier) async throws -> LocaleModel?
    func find(name: String) async throws -> LocaleModel?
    func set(_ locale: LocaleModel) async throws
    func set<Field>(_ field: KeyPath<LocaleModel, Field>, to value: Field.Value, for localeID: UUID) async throws
        where Field: QueryableProperty, Field.Model == LocaleModel
    func count() async throws -> Int
}
