//
//  ListDetailsViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListDetailsViewController: View {    
    @StateObject var feedsModelController = FeedsModelController()
    @StateObject var selectedFeedModelController = SelectedFeedModelController()
    @StateObject var modalModelController = ModalModelController()
    
    @State var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            ListViewController()
                .navigationTitle("Feeds")
            #if os(macOS)
                .navigationSplitViewColumnWidth(
                    min: 250, ideal: 300)
            #endif
        } detail: {
            DetailsViewController()
        }
        .environmentObject(feedsModelController)
        .environmentObject(selectedFeedModelController)
        .environmentObject(modalModelController)
    }
}

struct ListDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailsViewController()
    }
}
