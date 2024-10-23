//
//  CountryRepositoryError.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Fluent
import Vapor

enum CountryRepositoryError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingCountry
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
