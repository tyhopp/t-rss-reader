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
    @Binding var selectedFeedUrl: String?
    @State private var getFeedsResult: Result<[Feed], Error>?
    @State private var isUpserting: Bool = false
    
    let feedsService: FeedsService
    
    init(feedsService: FeedsService = FeedsService(), selectedFeedUrl: Binding<String?>) {
        self.feedsService = feedsService
        _selectedFeedUrl = selectedFeedUrl
    }
    
    enum FeedsError: Error {
        case feedsRequest
        case feedsDecode
    }
    
    func getFeeds() async {
        do {
            let (feedsData, feedsResponse) = try await feedsService.getFeeds()
            
            guard let feeds = try? JSONDecoder().decode([Feed].self, from: feedsData) else {
                getFeedsResult = .failure(FeedsError.feedsDecode)
                return
            }
            
            guard feedsResponse.statusCode() == 200 else {
                getFeedsResult = .failure(FeedsError.feedsRequest)
                return
            }
            
            feedsModelController.feeds = feeds
            
            getFeedsResult = .success(feeds)
        } catch {
            getFeedsResult = .failure(FeedsError.feedsRequest)
        }
    }
    
    func deleteFeed(url: String) {
        Task {
            do {
                isUpserting = true
                
                let (_, deletedFeedResponse) = try await feedsService.deleteFeed(url: url)
                
                guard deletedFeedResponse.statusCode() == 200 else {
                    // TODO: Show alert failure
                    isUpserting = false
                    return
                }
                
                feedsModelController.deleteFeedByUrl(url: url)
                selectedFeedUrl = nil
                isUpserting = false
            } catch {
                // TODO: Show alert failure
                isUpserting = false
            }
        }
    }
    
    @ViewBuilder var body: some View {
        Group {
            switch getFeedsResult {
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
                        List(selection: $selectedFeedUrl) {
                            ForEach(feeds, id: \.url) { feed in
                                ListItemView(feed: feed)
                                    // Long press on iOS/iPadOS, right click on macOS
                                    .contextMenu {
                                        if !isUpserting {
                                            Button("Delete") {
                                                deleteFeed(url: feed.url)
                                            }
                                        }
                                    }
                            }
                            // Slide to delete gesture on iOS/iPadOS, ignored on macOS
                            .onDelete(perform: { offsets in
                                if let index = offsets.first, let feed = feedsModelController.feeds?[index] {
                                    deleteFeed(url: feed.url)
                                }
                            })
                            .deleteDisabled(isUpserting)
                        }
                    }
                } else {
                    Text("No feeds yet")
                }
            }
        }
        .toolbar {
            HStack(alignment: .bottom) {
                Button("Add") {
                    print("TODO: Add")
                }
            }
        }
        .task {
            if case .none = getFeedsResult {
                await getFeeds()
            }
        }
    }
}
