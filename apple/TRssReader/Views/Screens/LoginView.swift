//
//  LoginView.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import SwiftUI

struct LoginView: View {
    @State private var password: String = ""
    @State private var loading: Bool = false
    @State private var result: Result<Bool, Error>?
    
    @EnvironmentObject private var tokenStore: TokenStore
    
    private var loginService: LoginService = LoginService()
    
    enum LoginError: Error {
        case tokenDecode
        case tokenNotReceived
        case tokenNotSet
        case unknown
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
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 50)
                
                Text("Enter your password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ResultMessageView(result: $result)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top], 4)
                
                SecureField("Password", text: $password) {
                    Task {
                        await submit()
                    }
                }
                .padding([.top, .bottom], 10)
                .textFieldStyle(.roundedBorder)
                .disabled(loading)
                
                Button(loading ? "Authorizing..." : "Log In", action: {
                    Task {
                        await submit()
                    }
                })
                .padding([.top], 6)
                .frame(alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .disabled(password.isEmpty || loading)
                
                Spacer()
            }
            .frame(
                idealWidth: 300,
                maxWidth: 300
            )
            .padding()
            .navigationTitle("Log In")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
