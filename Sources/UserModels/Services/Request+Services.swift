//
//  Request+Services.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

public extension Request {
    var countries: CountryRepositoryProtocol { application.repositories.countries.for(self) }
    var locations: LocationRepositoryProtocol { application.repositories.locations.for(self) }
    var locales: LocaleRepositoryProtocol { application.repositories.locales.for(self) }
    var languages: LanguageRepositoryProtocol { application.repositories.languages.for(self) }
	var localizations: LocalizationRepositoryProtocol { application.repositories.localizations.for(self) }
	var users: UserRepositoryProtocol { application.repositories.users.for(self) }
    var refreshTokens: RefreshTokenRepositoryProtocol { application.repositories.refreshTokens.for(self) }
    var emailTokens: EmailTokenRepositoryProtocol { application.repositories.emailTokens.for(self) }
    var passwordTokens: PasswordTokenRepositoryProtocol { application.repositories.passwordTokens.for(self) }
    var settings: UserSettingRepositoryProtocol { application.repositories.settings.for(self) }
}
