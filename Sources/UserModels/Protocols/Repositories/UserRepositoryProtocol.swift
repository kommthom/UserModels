//
//  UserRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent

public protocol UserRepositoryProtocol: DBRepositoryProtocol {
    func create(_ user: UserModel) async throws
    func delete(id: UUID, force: Bool) async throws
    func all() async throws -> [UserModel]
    func find(id: UUID?) async throws -> UserModel?
    func find(email: String) async throws -> UserModel?
    func set(_ user: UserModel) async throws
    func set<Field>(_ field: KeyPath<UserModel, Field>, to value: Field.Value, for userID: UUID) async throws where Field: QueryableProperty, Field.Model == UserModel
    func count() async throws -> Int
}

public protocol UserRepositoryMockProtocol {
    func createDemo(_ user: UserModel) async throws
}
