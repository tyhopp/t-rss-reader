//
//  Authorizable.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation

class AuthorizedService {
    private let defaultHeaders: [String: String] = ["content-type": "application/json"]
    
    var token: AnyObject? {
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
        
        return token
    }
    
    func headers() -> [String: String] {
        var headersInstance = defaultHeaders
        
        if let accessToken = token as? String {
            headersInstance.merge(["authorization": accessToken]) { (current, _) in current }
        }
        
        return headersInstance
    }
    
    func request(api: String) -> URLRequest {
        var request = URLRequest(url: URL(string: api)!)
        
        let headers = self.headers()
        
        for (key, value) in headersWithAuthorization {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
