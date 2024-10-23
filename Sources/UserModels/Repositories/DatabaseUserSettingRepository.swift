//
//  DatabaseUserSettingRepository.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 30.01.24.
//

import Vapor
import Fluent
import UserDTOs

public struct DatabaseUserSettingRepository: UserSettingRepositoryProtocol, DatabaseRepositoryProtocol, Sendable {
    public let database: Database
    private let logger = Logger(label: "reminders.backend.settings")
    
    public func createAll(userId: UserModel.IDValue) async throws  {
        var settings: [SettingModel] = .init()
        settings.append(SettingModel(sortOrder: 1, scope: .sidebarOptionsType, name: "settings.show_count", description: "settings.show_count", valueType: .bool, boolValue: true, intValue: nil, stringValue: nil, idValue: nil, jsonValue: nil, userId: userId))
        settings.append(SettingModel(sortOrder: 2, scope: .sidebarType, name: "settings.inbox", description: "settings.inbox", valueType: .json, boolValue: true, intValue: nil, stringValue: "tasks/inbox", idValue: nil, jsonValue: nil, userId: userId))
        settings.append(SettingModel(sortOrder: 3, scope: .sidebarType, name: "settings.today", description: "settings.today", valueType: .string, boolValue: true, intValue: nil, stringValue: "tasks/today", idValue: nil, jsonValue: nil, userId: userId))
        settings.append(SettingModel(sortOrder: 4, scope: .sidebarType, name: "settings.soon", description: "settings.soon", valueType: .string, boolValue: true, intValue: nil, stringValue: "tasks/soon", idValue: nil, jsonValue: nil, userId: userId))
        settings.append(SettingModel(sortOrder: 5, scope: .sidebarType, name: "settings.filter", description: "settings.filter", valueType: .json, boolValue: true, intValue: nil, stringValue: nil, idValue: nil, jsonValue: "[]", userId: userId))
        settings.append(SettingModel(sortOrder: 6, scope: .sidebarType, name: "settings.labels", description: "settings.labels", valueType: .string, boolValue: true, intValue: nil, stringValue: "tags/index", idValue: nil, jsonValue: nil, userId: userId))
        settings.append(SettingModel(sortOrder: 7, scope: .sidebarType, name: "settings.done", description: "settings.done", valueType: .string, boolValue: true, intValue: nil, stringValue: "tasks/done", idValue: nil, jsonValue: nil, userId: userId))
		for setting in settings {
			try await create( setting )
		}
    }

    public func create(_ setting: SettingModel) async throws {
        logger.info("Create Setting: \(setting.scope.rawValue)|\(setting.name)")
		do {
			try await setting
				.create(on: database)
		} catch let error {
			if let dbError = error as? DatabaseError, dbError.isConstraintFailure {
				logger.error("Create Setting: duplicate key -> \(setting.scope.rawValue)|\(setting.name)")
				throw AuthenticationError.emailAlreadyExists
			}
			logger.error("Create Setting: error -> \(error.localizedDescription)")
			throw error
		}
    }
    
    public func delete(id: UUID, force: Bool) async throws {
		try await SettingModel
            .query(on: database)
            .filter(\.$id == id)
            .delete(force: force)
    }
    
    public func all(userId: UUID?) async throws -> [SettingModel] {
		try await SettingModel
            .query(on: database)
            .join(UserModel.self, on: \SettingModel.$user.$id == \UserModel.$id)
            .filter(UserModel.self, \.$id == userId!)
            .sort(\.$sortOrder, .ascending)
            .all()
    }
    
    public func all(userId: UUID?, type: ScopeType) async throws -> [SettingModel] {
		try await SettingModel
            .query(on: database)
            .join(UserModel.self, on: \SettingModel.$user.$id == \UserModel.$id)
            .filter(UserModel.self, \.$id == userId!)
            .filter(SettingModel.self, \.$scope == type)
            .sort(\.$sortOrder, .ascending)
            .all()
    }
    
    public func sidebar(userId: UUID?) async throws -> [SettingModel] {
		try await SettingModel
            .query(on: database)
            .join(UserModel.self, on: \SettingModel.$user.$id == \UserModel.$id)
            .filter(UserModel.self, \.$id == userId!)
            .filter(SettingModel.self, \.$scope == ScopeType.sidebarType)
            .filter(SettingModel.self, \.$boolValue == true)
            .all()
    }
    
    public func find(id: UUID?) async throws -> SettingModel? {
		try await SettingModel
            .find(id, on: database)
    }
    
    public func find(userId: UUID?, scope: ScopeType, name: String) async throws -> SettingModel? {
		try await SettingModel
            .query(on: database)
            .join(UserModel.self, on: \SettingModel.$user.$id == \UserModel.$id)
            .filter(UserModel.self, \.$id == userId!)
            .filter(SettingModel.self, \.$scope == scope)
            .filter(SettingModel.self, \.$name == name)
            .first()
    }
    
    public func all(userId: UUID?, scope: ScopeType) async throws -> [SettingModel] {
		try await SettingModel
            .query(on: database)
            .join(UserModel.self, on: \SettingModel.$user.$id == \UserModel.$id)
            .filter(UserModel.self, \.$id == userId!)
            .filter(SettingModel.self, \.$scope == scope)
            .all()
    }
    
    public func set(_ setting: SettingModel) async throws {
		try await SettingModel
            .query(on: database)
            .filter(\.$id == setting.id!)
            //.set(\.$valueType, to: setting.valueType)
            .set(\.$boolValue, to: setting.boolValue)
            .set(\.$intValue, to: setting.intValue)
            .set(\.$stringValue, to: setting.stringValue)
            .set(\.$idValue, to: setting.idValue)
            .set(\.$jsonValue, to: setting.jsonValue)
            .update()
    }
    
    public func set<Field>(_ field: KeyPath<SettingModel, Field>, to value: Field.Value, for settingID: UUID) async throws
        where Field: QueryableProperty, Field.Model == SettingModel {
		try await SettingModel
            .query(on: database)
            .filter(\.$id == settingID)
            .set(field, to: value)
            .update()
    }
    
    public func count(userId: UUID?, scope: ScopeType) async throws -> Int {
		try await SettingModel
            .query(on: database)
            .join(UserModel.self, on: \SettingModel.$user.$id == \UserModel.$id)
            .filter(UserModel.self, \.$id == userId!)
            .filter(SettingModel.self, \.$scope == scope)
            .count()
    }
    
    public init(database: Database) {
        self.database = database
    }
}

extension Application.Repositories {
    public var settings: UserSettingRepositoryProtocol {
        guard let storage = storage.makeSettingRepository else {
            fatalError("SettingRepository not configured, use: app.settingRepository.use()")
        }
        
        return storage(app)
    }
    
    public func use(_ make: @escaping @Sendable (Application) -> (UserSettingRepositoryProtocol)) {
        storage.makeSettingRepository = make
    }
}

