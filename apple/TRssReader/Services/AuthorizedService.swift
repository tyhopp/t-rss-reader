//
//  Authorizable.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation

class AuthorizedService {
    var keychain: Keychain
    
    init(keychain: Keychain = Keychain()) {
        self.keychain = keychain
    }
    
    // URLRequest capitalizes header keys, so init keys capitalized for consistency under test
    let defaultHeaders: [String: String] = ["Content-Type": "application/json"]
    
    func headers() -> [String: String] {
        var headersInstance = defaultHeaders
        
        if let accessToken = keychain.getToken() as? String {
            headersInstance.merge(["Authorization": accessToken]) { (current, _) in current }
        }
        
        return headersInstance
    }
    
    func request(api: String) -> URLRequest {
        var request = URLRequest(url: URL(string: api)!)
        
        for (key, value) in self.headers() {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
