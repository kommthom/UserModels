//
//  AuthenticatedUser.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 20.01.24.
//

import Vapor
import UserDTOs

public struct AuthenticatedUser: Authenticatable {
    public let id: UUID
    public let name: String
    public let email: String
    public let isAdministrator: Bool
    public let locale: LocaleIdentifier
    public let timeZone: String

    // Fills in the AuthenticatedUser from parameters
    public init(id: UUID, name: String, email: String, isAdministrator: Bool, locale: LocaleIdentifier, timeZone: String) {
        self.id = id
        self.name = name
        self.email = email
        self.isAdministrator = isAdministrator
        self.locale = locale
        self.timeZone = timeZone
    }

    // Fills in the AuthenticatedUser from a UserModel
    // The model must contain a valid user
    public init(model user: UserModel) {
        self.id = user.id!
        self.name = user.fullName
        self.email = user.email
        self.isAdministrator = user.isAdmin
        self.locale = user.locale.identifier
        self.timeZone = user.location.timeZone
    }
}

// This is needed because certain stuff in fixed in Vapor authenticate
extension AuthenticatedUser: SessionAuthenticatable {
    public var sessionID: UUID { id }
}

// This is added to Request to make it easier to check for an administrator
extension Request {
	// Gets the AuthenticatedUser if any, and returns a Bool
	public func isAdministrator() -> Bool {
		guard let authenticatedUser = self.auth.get(AuthenticatedUser.self) else { return false }
		return authenticatedUser.isAdministrator
	}
	
	public func getAuthenticatedUser() throws -> AuthenticatedUser? {
		if let authenticatedUser = self.auth.get(AuthenticatedUser.self) {
			return authenticatedUser
		} else {
			throw AuthenticationError.userNotFound
		}
	}
}
