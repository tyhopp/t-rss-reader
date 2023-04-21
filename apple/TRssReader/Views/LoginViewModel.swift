//
//  LoginViewModel.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

struct LoginViewModel {
    var loginService: LoginService
    var tokenStore: TokenStorable
    
    init(loginService: LoginService = LoginService(), tokenStore: TokenStorable = TokenStore.shared) {
        self.loginService = loginService
        self.tokenStore = tokenStore
    }
    
    enum LoginViewModelError: Error {
        case tokenDecode
        case tokenNotReceived
        case tokenNotSet
        case unknown
    }
    
    func login(password: String) async -> Result<Bool, Error> {
        do {            
            let (loginData, loginResponse) = try await loginService.login(password: password)
            
            guard let token = try? JSONDecoder().decode(Token.self, from: loginData) else {
                return .failure(LoginViewModelError.tokenDecode)
            }
            
            guard loginResponse.statusCode() == 200 && !token.accessToken.isEmpty else {
                return .failure(LoginViewModelError.tokenNotReceived)
            }
            
            do {
                try tokenStore.setToken(token: token)
                return .success(true)
            } catch {
                return .failure(LoginViewModelError.tokenNotSet)
            }
        } catch {
            return .failure(LoginViewModelError.unknown)
        }
    }
}
