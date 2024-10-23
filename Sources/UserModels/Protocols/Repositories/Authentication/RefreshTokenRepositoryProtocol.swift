//
//  RefreshTokenRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 23.12.23.
//

import Foundation
import NIOCore

public protocol RefreshTokenRepositoryProtocol: DBRepositoryProtocol {
    func create(_ token: RefreshToken) async throws
    func find(id: UUID?) async throws -> RefreshToken?
    func find(token: String) async throws -> RefreshToken?
    func delete(_ token: RefreshToken) async throws
    func count() async throws -> Int
    func delete(for userID: UUID) async throws
}
