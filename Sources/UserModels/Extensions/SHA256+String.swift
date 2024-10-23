//
//  SHA256+String.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Crypto
import Foundation

extension SHA256 {
    /// Returns hex-encoded string
    public static func hash(_ string: String) -> String {
        SHA256.hash(data: string.data(using: .utf8)!)
    }
    
    /// Returns a hex encoded string
    public static func hash<D>(data: D) -> String where D : DataProtocol {
        SHA256.hash(data: data).hex
    }
}
