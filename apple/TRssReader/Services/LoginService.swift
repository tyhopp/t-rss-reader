//
//  LoginService.swift
//  TRssReader
//
//  Created by Ty Hopp on 6/4/23.
//

import Foundation

class LoginService {
    @Sendable func login(password: String) async throws -> (Data, URLResponse) {
        guard let url = URL(string: Env.LOGIN_API) else {
            throw ServiceError.url
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(password, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        return try await URLSession.shared.data(for: request)
    }
}
