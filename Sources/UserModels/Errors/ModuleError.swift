//
//  ModuleError.swift
//  UserModels
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Vapor

protocol ModuleError: AbortError, DebuggableError {}
