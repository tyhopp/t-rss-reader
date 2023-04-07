//
//  Keychain.swift
//  TRssReader
//
//  Created by Ty Hopp on 4/4/23.
//

import Foundation

class Keychain {
    func getToken() -> Token? {
        var token: AnyObject?
        
        let query: [String: AnyObject] = [
            // Key for item
            kSecAttrService as String: ACCESS_TOKEN_KEY as AnyObject,
            
            // Read only one item
            kSecMatchLimit as String: kSecMatchLimitOne,
            
            // Retrieve data for the item
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        // Token copied to memory address if it exists
        SecItemCopyMatching(query as CFDictionary, &token)
        
        return token as? Token
    }
}
