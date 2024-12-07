//
//  ListView.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListView: View {
    @EnvironmentObject var feedsStore: FeedsStore
    @EnvironmentObject var selectedFeedStore: SelectedFeedStore
    
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
            
            feedsStore.feeds = feeds
            
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
                if let feeds = feedsStore.feeds {
                    if feeds.isEmpty {
                        Text("No feeds yet")
                    } else {
                        #if os(iOS)
                        Spacer()
                            .frame(height: 10)
                        #endif
                        ListActionsView()
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

#Preview {
    let feedsStore = FeedsStore()
    let selectedFeedStore = SelectedFeedStore()
    
    feedsStore.feeds = [
        Feed(name: "Feed 1", url: "https://example.com/feed1", createdAt: Date().nowInMs),
        Feed(name: "Feed 2", url: "https://example.com/feed2", createdAt: Date().nowInMs)
    ]
    
    selectedFeedStore.feedUrl = "https://example.com/feed1"
    
    return ListView(feedsService: MockFeedsService())
        .environmentObject(feedsStore)
        .environmentObject(selectedFeedStore)
}
