//
//  UserModel.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor
import Fluent
import JWT
import UserDTOs
import AuthenticationDTOs

public final class UserModel: Model, Authenticatable, @unchecked Sendable {
    public static let schema = "users"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "full_name")
    public var fullName: String
    
    @Field(key: "email")
    public var email: String
    
    @Field(key: "image_url")
    public var imageURL: String?
    
    @Field(key: "password_hash")
    public var passwordHash: String
    
    @Field(key: "is_admin")
    public var isAdmin: Bool
    
    @Field(key: "is_email_verified")
    public var isEmailVerified: Bool
    
    @Timestamp(key: "deleted_at", on: .delete)
    public var deletedAt: Date?
    
    @Children(for: \.$user)
    public var settings: [SettingModel]
    
    @Parent(key: "locale")
    public var locale: LocaleModel
    
    @Parent(key: "location")
    public var location: LocationModel
    
    public init() {}
    
    public init(id: UUID? = nil, fullName: String, email: String, passwordHash: String, isAdmin: Bool = false, isEmailVerified: Bool = false, imageURL: String? = nil, localeId: UUID, locationId: UUID) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.passwordHash = passwordHash
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
        self.imageURL = imageURL
        self.$locale.id = localeId
        self.$location.id = locationId
    }
    
    public convenience init(with payload: Payload) {
		self.init(
			id: payload.userID.rawValue,
			fullName: payload.fullName,
			email: payload.email,
			passwordHash: "",
			isAdmin: payload.isAdmin,
			isEmailVerified: false,
			imageURL: payload.imageURL,
			localeId: (payload.locale.id?.rawValue)!,
			locationId: (payload.location.id?.rawValue)!
		)
    }
    
    public convenience init(with dto: UserDTO, hash: String) throws {
		self.init(
			id: dto.id?.rawValue,
			fullName: dto.fullName,
			email: dto.email,
			passwordHash: hash,
			isAdmin: dto.isAdmin,
			isEmailVerified: false,
			imageURL: dto.imageURL,
			localeId: (dto.locale.id?.rawValue)!,
			locationId: (dto.location.id?.rawValue)!
		)
    }
}

extension Payload {
	public init(with model: UserModel, localization: @escaping @Sendable (String) -> String) throws {
		self.init(
			userID: UserDTO.UserId(try model.requireID()),
			fullName: model.fullName,
			email: model.email,
			isAdmin: model.isAdmin,
			imageURL: model.imageURL,
			locale: LocaleDTO(
				with: model.locale,
				localization: localization
			),
			location: LocationDTO(
				with: model.location,
				localization: localization
			),
			exp: ExpirationClaim(
				value: Date()
					.addingTimeInterval(
						Double(
							Environment.get("ACCESS_TOKEN_LIFETIME") ?? "3600"
						)!
					)
			)
		)
	}
}

extension UserDTO {
    public init(with model: UserModel, localization: @escaping @Sendable (String) -> String) {
		self.init(
			id: UserDTO.UserId(model.id!),
			fullName: model.fullName,
			email: model.email,
			imageURL: model.imageURL,
			password: "********",
			confirmPassword: nil,
			isAdmin: model.isAdmin,
			locale: LocaleDTO(
				with: model.locale,
				localization: localization
			),
			location: LocationDTO(
				with: model.location,
				localization: localization
			)
		)
    }
}

extension UsersDTO {
    public init(one: UserModel, localization: @escaping @Sendable (String) -> String) {
		self.init(users: [UserDTO(with: one, localization: localization)])
    }

    public init(many: [UserModel], localization: @escaping @Sendable (String) -> String) {
		self.init(users: many.compactMap { UserDTO(with: $0, localization: localization) })
    }
}
