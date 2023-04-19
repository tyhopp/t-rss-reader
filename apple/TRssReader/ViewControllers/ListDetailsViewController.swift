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
    @State private var selectedFeedUrl: String?
    
    // TODO: Selected feed state
    
    var body: some View {
        NavigationSplitView {
            ListViewController(selectedFeedUrl: $selectedFeedUrl)
                .navigationTitle("Feeds")
        } detail: {
            DetailsViewController(selectedFeedUrl: $selectedFeedUrl)
        }
        .environmentObject(feedsModelController)
    }
}

struct ListDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailsViewController()
    }
}
