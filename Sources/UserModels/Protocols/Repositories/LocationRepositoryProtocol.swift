//
//  LocationRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Vapor
import Fluent

public protocol LocationRepositoryProtocol: DBRepositoryProtocol, LocationRepositoryMockProtocol {
    func create(_ location: LocationModel) async throws
    func delete(id: UUID) async throws
    func all() async throws -> [LocationModel]
    func find(id: UUID) async throws -> LocationModel?
    func find(identifier: String) async throws -> LocationModel?
    func find(countryId: UUID) async throws -> [LocationModel]
    func set(_ location: LocationModel) async throws
    func set<Field>(_ field: KeyPath<LocationModel, Field>, to value: Field.Value, for locationID: UUID) async throws
        where Field: QueryableProperty, Field.Model == LocationModel
    func count() async throws -> Int
}

public protocol LocationRepositoryMockProtocol {
}
