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
    
    private var loginService: LoginService = LoginService()
    private var keychainManager: KeychainManager = KeychainManager()
    
    func submit() async {
        do {
            let (loginData, loginResponse) = try await loginService.login(password: password)
            
            guard let token = try? JSONDecoder().decode(Token.self, from: loginData) else {
                // TODO: Display error state
                print("Failed to login")
                return
            }

            guard loginResponse.statusCode() == 200 && !token.accessToken.isEmpty else {
                // TODO: Display error state
                print("Failed to login")
                return
            }
            
            keychainManager.setToken(token: loginData)
        } catch {
            // TODO: Display error state
            print(error)
        }
    }
    
    var body: some View {
        VStack {
            Text("Enter your password")
            SecureField("Password", text: $password) {
                Task {
                    await submit()
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding()
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
