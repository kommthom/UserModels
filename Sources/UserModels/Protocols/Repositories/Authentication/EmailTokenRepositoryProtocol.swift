//
//  EmailTokenRepositoryProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 23.12.23.
//

import Foundation
import NIOCore

public protocol EmailTokenRepositoryProtocol: DBRepositoryProtocol {
    func find(token: String) async throws -> EmailToken?
    func create(_ emailToken: EmailToken) async throws
    func delete(_ emailToken: EmailToken)  async throws
    func find(userID: UUID) async throws -> EmailToken?
}
