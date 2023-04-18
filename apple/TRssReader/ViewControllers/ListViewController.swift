//
//  ListViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListViewController: View {
    @EnvironmentObject var feedsModelController: FeedsModelController
    
    @ViewBuilder var body: some View {
        switch feedsModelController.result {
        case .none:
            // TODO: Proper loading indicator
            Text("Loading")
            
        case .failure(_):
            Text("Failed to get feeds")
            // TODO: Retry logic
            
        case .success(let feeds):
            if feeds.isEmpty {
                Text("No feeds yet")
                // TODO: Add feed button
            } else {
                List(feeds, id: \.url) { feed in
                    NavigationLink(feed.name, destination: DetailsViewController(selectedFeed: feed))
                }
            }
        }
    }
}
