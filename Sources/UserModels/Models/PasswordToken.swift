//
//  PasswordToken.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent
import UserDTOs

public final class PasswordToken: Model, @unchecked Sendable {
	public static let schema: String = "user_password_tokens"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Parent(key: "user_id")
    public var user: UserModel

    @Field(key: "token")
    public var token: String
    
    @Field(key: "expires_at")
    public var expiresAt: Date
    
    public init() {}
    
    public init(id: UUID? = nil, userID: UUID, token: String, expiresAt: Date? = nil) {
        self.id = id
        self.$user.id = userID
        self.token = token
        self.expiresAt = expiresAt ?? Date()
			.addingTimeInterval(
				Double(
					Environment.get("RESET_PASSWORD_TOKEN_LIFETIME") ?? "3600"
				)!
		)
    }
}
