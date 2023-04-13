//
//  KeychainManager.swift
//  TRssReader
//
//  Created by Ty Hopp on 4/4/23.
//

import Foundation
import Keychain

enum KeychainKey {
    @Keychain(service: "token", account: "t-rss-reader") static public var token: String?
}

struct KeychainManager {
    func getToken() -> Token? {
        guard let tokenString = KeychainKey.token?.utf8 else {
            return nil
        }
        
        return try? JSONDecoder().decode(Token.self, from: Data(tokenString))
    }
    
    func setToken(token: Data) {
        KeychainKey.token = String(decoding: token, as: UTF8.self)
    }
}
