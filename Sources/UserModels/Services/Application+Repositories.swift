//
//  Application+Repositories.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent

extension Application: Sendable {
	public struct Repositories: Sendable {
		public struct Provider: Sendable {
            public static var database: Self {
                .init {
                    $0.repositories.use { DatabaseCountryRepository(database: $0.db) }
                    $0.repositories.use { DatabaseLocationRepository(database: $0.db) }
                    $0.repositories.use { DatabaseLocaleRepository(database: $0.db) }
                    $0.repositories.use { DatabaseLanguageRepository(database: $0.db) }
					$0.repositories.use { DatabaseLocalizationRepository(database: $0.db) }
					$0.repositories.use { DatabaseUserRepository(database: $0.db) }
                    $0.repositories.use { DatabaseEmailTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseRefreshTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabasePasswordTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseUserSettingRepository(database: $0.db) }
                }
            }
            public let run: @Sendable (Application) -> ()
        }
        
		public final class Storage: @unchecked Sendable {
            public var makeCountryRepository: (@Sendable (Application) -> CountryRepositoryProtocol)?
            public var makeLocationRepository: (@Sendable (Application) -> LocationRepositoryProtocol)?
            public var makeLocaleRepository: (@Sendable (Application) -> LocaleRepositoryProtocol)?
            public var makeLanguageRepository: (@Sendable (Application) -> LanguageRepositoryProtocol)?
            public var makeUserRepository: (@Sendable (Application) -> UserRepositoryProtocol)?
            public var makeEmailTokenRepository: (@Sendable (Application) -> EmailTokenRepositoryProtocol)?
            public var makeRefreshTokenRepository: (@Sendable (Application) -> RefreshTokenRepositoryProtocol)?
            public var makePasswordTokenRepository: (@Sendable (Application) -> PasswordTokenRepositoryProtocol)?
			public var makeSettingRepository: (@Sendable (Application) -> UserSettingRepositoryProtocol)?
			public var makeLocalizationRepository: (@Sendable (Application) -> LocalizationRepositoryProtocol)?
			
            public init() { }
        }
        
        public struct Key: StorageKey {
            public typealias Value = Storage
        }
        
        public let app: Application
        
        public func use(_ provider: Provider) {
            provider.run(app)
        }
        
        public var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            return app.storage[Key.self]!
        }
    }
    
    public var repositories: Repositories {
        .init(app: self)
    }
}
