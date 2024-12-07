//
//  LoginView.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import SwiftUI

enum LoginError: Error {
    case tokenDecode
    case tokenNotReceived
    case tokenNotSet
    case unknown
}

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 50)
                
                Text("Enter your password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ResultMessageView(result: $viewModel.result)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top], 4)
                
                SecureField("Password", text: $viewModel.password) {
                    Task {
                        await viewModel.submit()
                    }
                }
                .padding([.top, .bottom], 10)
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.loading)
                
                Button(viewModel.loading ? "Authorizing..." : "Log In", action: {
                    Task {
                        await viewModel.submit()
                    }
                })
                .padding([.top], 6)
                .frame(alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.password.isEmpty || viewModel.loading)
                
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

#Preview {
    LoginView(viewModel: LoginViewModel())
}
