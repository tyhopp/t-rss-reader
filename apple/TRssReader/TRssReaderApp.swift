//
//  TRssReaderApp.swift
//  TRssReader
//
//  Created by Ty Hopp on 29/3/23.
//

import SwiftUI

@main
struct TRssReaderApp: App {
    @StateObject private var tokenStore = TokenStore.shared
    
    var body: some Scene {
        WindowGroup {
            TRssReaderContentView()
                .environmentObject(tokenStore)
        }
    }
}

struct TRssReaderContentView: View {
    @EnvironmentObject var tokenStore: TokenStore
    
    var body: some View {
        Group {
            if tokenStore.store.maybeValid {
                ListDetailsView()
            } else {
                LoginView(viewModel: LoginViewModel(tokenStore: tokenStore))
            }
        }
    }
}

#Preview("Unauthenticated") {
    let tokenStore = TokenStore.shared
    tokenStore.store.maybeValid = false
    return TRssReaderContentView()
        .environmentObject(tokenStore)
}

#Preview("Authenticated") {
    let tokenStore = TokenStore.shared
    tokenStore.store.maybeValid = true
    return TRssReaderContentView()
        .environmentObject(tokenStore)
}
