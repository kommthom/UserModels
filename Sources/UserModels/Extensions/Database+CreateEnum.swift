//
//  Database+CreateEnum.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 24.03.24.
//

import Foundation
import Vapor
import FluentKit

extension Database {
    public func createEnum(_ name: String, allCases: [String]) async throws-> DatabaseSchema.DataType {
        var enumBuilder = self.enum(name)
        for enumCase in allCases {
            enumBuilder = enumBuilder.case(enumCase)
        }
        return try await enumBuilder.create()
    }
}
