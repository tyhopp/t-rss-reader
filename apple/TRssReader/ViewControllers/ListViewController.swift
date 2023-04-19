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
    @State private var result: Result<[Feed], Error>?
    
    let feedsService: FeedsService
    
    init(feedsService: FeedsService = FeedsService()) {
        self.feedsService = feedsService
    }
    
    enum FeedsError: Error {
        case feedsRequest
        case feedsDecode
    }
    
    @ViewBuilder var body: some View {
        Group {
            switch result {
            case .none:
                ProgressView()
                
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
        }.task {
            if case .none = result {
                do {
                    let (feedsData, feedsResponse) = try await feedsService.getFeeds()
                    
                    guard let feeds = try? JSONDecoder().decode([Feed].self, from: feedsData) else {
                        result = .failure(FeedsError.feedsDecode)
                        return
                    }
                    
                    guard feedsResponse.statusCode() == 200 else {
                        result = .failure(FeedsError.feedsRequest)
                        return
                    }
                    
                    result = .success(feeds)
                } catch {
                    result = .failure(FeedsError.feedsRequest)
                }
            }
        }
    }
}
