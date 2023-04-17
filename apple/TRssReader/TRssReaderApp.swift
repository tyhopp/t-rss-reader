//
//  TRssReaderApp.swift
//  TRssReader
//
//  Created by Ty Hopp on 29/3/23.
//

import SwiftUI

@main
struct TRssReaderApp: App {
    @StateObject var tokenModelController = TokenModelController()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (tokenModelController.store.maybeValid) {
                    ListDetailsViewController()
                } else {
                    LoginViewController()
                }
            }.environmentObject(tokenModelController)
        }
    }
}
