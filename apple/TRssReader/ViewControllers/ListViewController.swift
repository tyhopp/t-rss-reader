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
    @EnvironmentObject var selectedFeedModelController: SelectedFeedModelController
    
    @State private var feedsResult: Result<[Feed], Error>?
    
    let feedsService: FeedsService
    
    init(feedsService: FeedsService = FeedsService()) {
        self.feedsService = feedsService
    }
    
    enum FeedsError: Error {
        case feedsRequest
        case feedsDecode
    }
    
    func getFeeds() async {
        do {
            let (feedsData, feedsResponse) = try await feedsService.getFeeds()
            
            guard let feeds = try? JSONDecoder().decode([Feed].self, from: feedsData) else {
                feedsResult = .failure(FeedsError.feedsDecode)
                return
            }
            
            guard feedsResponse.statusCode() == 200 else {
                feedsResult = .failure(FeedsError.feedsRequest)
                return
            }
            
            feedsModelController.feeds = feeds
            
            feedsResult = .success(feeds)
        } catch {
            feedsResult = .failure(FeedsError.feedsRequest)
        }
    }
    
    @ViewBuilder var body: some View {
        Group {
            switch feedsResult {
            case .none:
                ProgressView()
            case .failure(_):
                Text("Failed to get feeds")
                // TODO: Retry logic
            case .success(_):
                if let feeds = feedsModelController.feeds {
                    if feeds.isEmpty {
                        Text("No feeds yet")
                    } else {
                        ListActionsViewController()
                    }
                } else {
                    Text("No feeds yet")
                }
            }
        }
        .task {
            if case .none = feedsResult {
                await getFeeds()
            }
        }
    }
}
