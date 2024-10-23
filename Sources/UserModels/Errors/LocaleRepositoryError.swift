//
//  LocaleRepositoryError.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Fluent
import Vapor

enum LocaleRepositoryError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingLocale
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
