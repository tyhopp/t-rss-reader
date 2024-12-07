//
//  LoginViewModel.swift
//  TRssReader
//
//  Created by Ty Hopp on 4/12/24.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var loading: Bool = false
    @Published var result: Result<Bool, LoginError>?
    
    private let loginService: LoginService
    private let tokenStore: TokenStore
    
    init(loginService: LoginService = LoginService(), tokenStore: TokenStore = TokenStore.shared) {
        self.loginService = loginService
        self.tokenStore = tokenStore
    }
    
    func login() async {
        do {
            loading = true
            
            let (loginData, loginResponse) = try await loginService.login(password: password)
            
            loading = false
            
            guard let token = try? JSONDecoder().decode(Token.self, from: loginData) else {
                result = .failure(LoginError.tokenDecode)
                return
            }
            
            guard loginResponse.statusCode() == 200 && !token.accessToken.isEmpty else {
                result = .failure(LoginError.tokenNotReceived)
                return
            }
            
            do {
                try tokenStore.setToken(token: token)
                result = .success(true)
            } catch {
                result = .failure(LoginError.tokenNotSet)
            }
        } catch {
            result = .failure(LoginError.unknown)
        }
    }
    
    func submit() async {
        await login()
        try? await Task.sleep(for: .seconds(3))
        result = nil
    }
}
