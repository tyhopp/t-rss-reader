//
//  AuthorizedService.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation
import Keychain

class AuthorizedService {
    let defaultHeaders: [String: String] = ["Content-Type": "application/json"]
    let keychainManager: KeychainManager
    
    init(keychainManager: KeychainManager = KeychainManager()) {
        self.keychainManager = keychainManager
    }
    
    func url(api: String) throws -> URL {
        guard let url = URL(string: api) else {
            throw ServiceError.url
        }
        
        return url
    }
    
    func headers() throws -> [String: String] {
        var headersInstance = defaultHeaders
        
        if let token = keychainManager.getToken() {
            headersInstance.merge(["Authorization": token.accessToken]) { (current, _) in current }
        } else {
            throw ServiceError.accessToken
        }
        
        return headersInstance
    }
    
    func request(api: String, queryItems: [URLQueryItem] = []) throws -> URLRequest {
        var url = try self.url(api: api)
        
        if !queryItems.isEmpty {
            url.append(queryItems: queryItems)
        }
        
        var request = URLRequest(url: url)
        
        do {
            for (key, value) in try self.headers() {
                request.setValue(value, forHTTPHeaderField: key)
            }
        } catch {
            throw ServiceError.headers
        }
        
        return request
    }
}
