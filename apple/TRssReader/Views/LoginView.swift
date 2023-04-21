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
    
    private var loginViewModel = LoginViewModel()
    
    func submit() async {
        result = await loginViewModel.login(password: password)
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
                idealWidth: 300.0,
                maxWidth: 300.0
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
