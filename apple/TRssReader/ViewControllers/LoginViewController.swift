//
//  LoginViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import SwiftUI

struct LoginViewController: View {
    @State private var password: String = ""
    @State private var loading: Bool = false
    @State private var result: Result<Bool, Error>?
    
    @EnvironmentObject private var tokenModelController: TokenModelController
    
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
                try tokenModelController.setToken(token: token)
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
        VStack {
            Text("Enter your password")
            Group {
                ResultMessageView(result: $result)
                SecureField("Password", text: $password) {
                    Task {
                        await submit()
                    }
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                .disabled(loading)
            }
            Button(loading ? "Authorizing..." : "Log In", action: {
                Task {
                    await submit()
                }
            })
            .disabled(password.isEmpty || loading)
            Spacer()
        }
        .frame(
            idealWidth: 300.0,
            maxWidth: 300.0,
            alignment: .center
        )
        .padding()
        .navigationTitle("t-rss-reader")
    }
}

struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewController()
    }
}
