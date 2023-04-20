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
    @StateObject var selectedFeedModelController = SelectedFeedModelController.shared
    
    var body: some View {
        NavigationSplitView {
            ListViewController()
                .navigationSplitViewColumnWidth(
                    min: 275, ideal: 400)
                .navigationTitle("Feeds")
        } detail: {
            DetailsViewController()
        }
        .environmentObject(feedsModelController)
        .environmentObject(selectedFeedModelController)
    }
}

struct ListDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailsViewController()
    }
}
