//
//  TRssReaderApp.swift
//  TRssReader
//
//  Created by Ty Hopp on 29/3/23.
//

import SwiftUI

@main
struct TRssReaderApp: App {
    @StateObject var tokenStore = TokenStore.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (tokenStore.store.maybeValid) {
                    ListDetailsView()
                } else {
                    LoginView()
                        .environmentObject(tokenStore)
                }
            }
        }
    }
}
