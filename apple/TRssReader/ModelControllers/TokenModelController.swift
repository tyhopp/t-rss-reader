//
//  TokenModelController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation

struct TokenModelStore {
    var maybeValid: Bool = false
    var token: Token?
}

enum TokenModelError: Error {
    case jsonEncodeFailure
}

protocol TokenModelControllable {
    var store: TokenModelStore { get set }
    
    func getTokenFromKeychain() -> Token?
    
    func setToken(token: Token) throws
}

final class TokenModelController: TokenModelControllable, ObservableObject {
    @Published var store = TokenModelStore()

    private var date: Date = Date()
    
    init() {        
        if let tokenInKeychain = getTokenFromKeychain() {
            if (!tokenInKeychain.accessToken.isEmpty && tokenInKeychain.expiresIn > date.nowInMs) {
                store = TokenModelStore(maybeValid: true, token: tokenInKeychain)
            }
        }
    }
    
    func getTokenFromKeychain() -> Token? {
        guard let tokenString = KeychainKey.token?.utf8 else {
            return nil
        }
        
        return try? JSONDecoder().decode(Token.self, from: Data(tokenString))
    }
    
    func setToken(token: Token) throws {
        guard let jsonData = try? JSONEncoder().encode(token) else {
            throw TokenModelError.jsonEncodeFailure
        }
        
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        KeychainKey.token = jsonString
        
        store = TokenModelStore(maybeValid: true, token: token)
    }
}
