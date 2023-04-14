//
//  LoginViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import SwiftUI

// TODO: Implement
struct LoginViewController: View {
    @State private var password: String = ""
    @State private var result: Result<Bool, Error>?
    
    private var loginService: LoginService = LoginService()
    private var keychainManager: KeychainManager = KeychainManager()
    
    enum LoginError: Error {
        case tokenDecode
        case tokenNotReceived
        case unknown
    }
    
    func submit() async {
        do {
            let (loginData, loginResponse) = try await loginService.login(password: password)
            
            guard let token = try? JSONDecoder().decode(Token.self, from: loginData) else {
                result = .failure(LoginError.tokenDecode)
                return
            }

            guard loginResponse.statusCode() == 200 && !token.accessToken.isEmpty else {
                result = .failure(LoginError.tokenNotReceived)
                return
            }
            
            keychainManager.setToken(token: loginData)
            
            result = .success(true)
        } catch {
            result = .failure(LoginError.unknown)
        }
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
            }
            // TODO: Display loading state
            Button("Log In", action: {
                Task {
                    await submit()
                }
            })
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
