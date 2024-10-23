//
//  UserMigrations.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 14.10.24.
//

import Vapor

public func userMigrations(_ app: Application) throws {
	// Initial Migrations
	app.logger.info("Add user migrations")
	app.migrations.add(CreateCountry())
	app.migrations.add(CreateLocation())
	app.migrations.add(CreateLanguage())
	app.migrations.add(CreateLocale())
	app.migrations.add(CreateCountryLocale())
	app.migrations.add(CreateLocation())
	app.migrations.add(CreateUser())
//	app.migrations.add(CreateBasicDataContent())
	app.migrations.add(CreateRefreshToken())
	app.migrations.add(CreateEmailToken())
	app.migrations.add(CreatePasswordToken())
}
