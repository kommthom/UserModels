//
//  UserRepositoryError.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 06.02.24.
//

import Fluent
import Vapor

enum UserRepositoryError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingUser
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
