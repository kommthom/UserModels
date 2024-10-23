//
//  LocationRepositoryError.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Fluent
import Vapor

enum LocationRepositoryError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingLocation
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
