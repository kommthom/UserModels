//
//  RequestServiceProtocol.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

public protocol RequestServiceProtocol {
    func `for`(_ req: Request) -> Self
}
