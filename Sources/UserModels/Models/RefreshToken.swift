//
//  RefreshToken.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent
import UserDTOs

public final class RefreshToken: Model, @unchecked Sendable {
    public static let schema = "user_refresh_tokens"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "token")
    public var token: String
    
    @Parent(key: "user_id")
    public var user: UserModel
    
    @Field(key: "expires_at")
    public var expiresAt: Date
    
    @Field(key: "issued_at")
    public var issuedAt: Date
    
    public init() {}
    
    public init(id: UUID? = nil, token: String, userID: UUID, expiresAt: Date? = nil, issuedAt: Date = Date()) {
        self.id = id
        self.token = token
        self.$user.id = userID
		self.expiresAt = expiresAt ?? Date()
			.addingTimeInterval(
				Double(
					Environment.get("REFRESH_TOKEN_LIFETIME") ?? "3600"
				)!
		)
        self.issuedAt = issuedAt
    }
}
