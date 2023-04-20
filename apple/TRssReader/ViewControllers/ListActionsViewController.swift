//
//  ListActionsViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 20/4/23.
//

import SwiftUI

struct ListActionsViewController: View {
    @EnvironmentObject var feedsModelController: FeedsModelController
    @EnvironmentObject var selectedFeedModelController: SelectedFeedModelController
    
    @State private var isUpserting: Bool = false
    
    let feedsService: FeedsService
    
    init(feedsService: FeedsService = FeedsService()) {
        self.feedsService = feedsService
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
                selectedFeedModelController.feedUrl = nil
                isUpserting = false
            } catch {
                // TODO: Show alert failure
                isUpserting = false
            }
        }
    }
    
    var body: some View {
        if let feeds = feedsModelController.feeds {
            if feeds.isEmpty {
                Text("No feeds yet")
            } else {
                List(selection: $selectedFeedModelController.feedUrl) {
                    ForEach(feeds, id: \.url) { feed in
                        ListItemView(feed: feed)
                            .contextMenu {
                                if !isUpserting {
                                    Button("Delete") {
                                        deleteFeed(url: feed.url)
                                    }
                                }
                            }
                    }
                    .onDelete(perform: { offsets in
                        if let index = offsets.first, let feed = feedsModelController.feeds?[index] {
                            deleteFeed(url: feed.url)
                        }
                    })
                    .deleteDisabled(isUpserting)
                }
                .toolbar {
                    HStack(alignment: .bottom) {
                        Button("Add") {
                            print("TODO: Add")
                        }
                    }
                }
            }
        } else {
            Text("No feeds yet")
        }
    }
}

struct ListActionsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListActionsViewController()
    }
}
