//
//  ApplicationServiceProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 15.05.24.
//

import Vapor

public protocol ApplicationServiceProtocol {
    func `for`(_ app: Application) -> Self
}
