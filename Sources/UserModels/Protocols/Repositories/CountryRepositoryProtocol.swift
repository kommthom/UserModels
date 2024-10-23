//
//  CountryRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent
import UserDTOs

public protocol CountryRepositoryProtocol: DBRepositoryProtocol {
    func create(_ country: CountryModel) async throws
    func createLink(countryId: UUID?, localeId: UUID) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [CountryModel]
    func find(id: UUID?) async throws -> CountryModel?
    func find(identifier: String) async throws -> CountryModel?
    func set(_ country: CountryModel) async throws
    func set<Field>(_ field: KeyPath<CountryModel, Field>, to value: Field.Value, for countryID: UUID) async throws
        where Field: QueryableProperty, Field.Model == CountryModel
    func count(userId: UUID?) async throws -> Int
}
