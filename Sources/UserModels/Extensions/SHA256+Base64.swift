//
//  SHA256+Base64.swift
//
//
//  Created by Thomas Benninghaus on 11.12.23.
//

import Crypto
import Foundation

extension SHA256Digest {
    public var base64: String {
        Data(self).base64EncodedString()
    }
    
    public var base64URLEncoded: String {
        Data(self).base64URLEncodedString()
    }
}

