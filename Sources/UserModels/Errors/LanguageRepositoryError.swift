//
//  LanguageRepositoryError.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 18.05.24.
//

import Fluent
import Vapor

enum LanguageRepositoryError: Error {
    case idParameterMissing
    case idParameterInvalid
    case missingLanguage
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
