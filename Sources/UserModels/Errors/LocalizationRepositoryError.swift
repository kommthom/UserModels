//
//  LocalizationRepositoryError.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 13.05.24.
//

import Foundation

public enum LocalizationRepositoryError: Error {
    case parsingFailure(message: String)
    case idParameterMissing
    case idParameterInvalid
    case missingLocalization
    case invalidForm
    case unableToCreateNewRecord
    case unableToUpdateRecord
    case unableToDeleteRecord
}
