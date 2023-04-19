//
//  ListDetailsViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListDetailsViewController: View {
    @EnvironmentObject var tokenModelController: TokenModelController
    @StateObject var feedsModelController = FeedsModelController.shared
    
    // TODO: Selected feed state
    
    var body: some View {
        NavigationSplitView {
            ListViewController()
                .navigationTitle("Feeds")
        } detail: {
            EmptyView()
//            switch feedsModelController.result {
//            case .success(let feeds):
//                if (!feeds.isEmpty) {
//                    Text("Select a feed to view entries")
//                    // TODO: Button to select random feed
//                }
//            case .failure(_):
//                Text("Failed to get feeds")
//            case .none:
//                EmptyView()
//            }
        }
        .environmentObject(feedsModelController)
    }
}

struct ListDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailsViewController()
    }
}
