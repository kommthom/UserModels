//
//  PasswordTokenRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 23.12.23.
//

import Foundation
import NIOCore

public protocol PasswordTokenRepositoryProtocol: DBRepositoryProtocol {
    func find(userID: UUID) async throws -> PasswordToken?
    func find(token: String) async throws -> PasswordToken?
    func count() async throws -> Int
    func create(_ passwordToken: PasswordToken) async throws
    func delete(_ passwordToken: PasswordToken) async throws
    func delete(for userID: UUID) async throws
}
