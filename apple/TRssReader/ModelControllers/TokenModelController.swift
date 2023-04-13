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

class TokenModelController: ObservableObject {
    @Published var store = TokenModelStore()

    private var keychainManager: KeychainManager = KeychainManager()
    private var date: Date = Date()
    
    init() {
        if let tokenInKeychain = keychainManager.getToken() {
            if (!tokenInKeychain.accessToken.isEmpty && tokenInKeychain.expiresIn > date.nowInMs) {
                store = TokenModelStore(maybeValid: true, token: tokenInKeychain)
            }
        }
    }
}
