//
//  UserSettingRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 30.01.24.
//

import Vapor
import Fluent
import UserDTOs

public protocol UserSettingRepositoryProtocol: DBRepositoryProtocol {
    func create(_ setting: SettingModel) async throws
    func createAll(userId: UserModel.IDValue) async throws
    func delete(id: UUID, force: Bool) async throws
    func all(userId: UUID?) async throws -> [SettingModel]
    func all(userId: UUID?, type: ScopeType) async throws -> [SettingModel]
    func sidebar(userId: UUID?) async throws -> [SettingModel]
    func find(id: UUID?) async throws -> SettingModel?
    func find(userId: UUID?, scope: ScopeType, name: String) async throws -> SettingModel?
    func all(userId: UUID?, scope: ScopeType) async throws -> [SettingModel]
    func set(_ setting: SettingModel) async throws
    func set<Field>(_ field: KeyPath<SettingModel, Field>, to value: Field.Value, for settingID: UUID) async throws
        where Field: QueryableProperty, Field.Model == SettingModel
    func count(userId: UUID?, scope: ScopeType) async throws -> Int
}

public protocol UserSettingRepositoryMockProtocol {
    func createDemo(userId: UserModel.IDValue) async throws
}
