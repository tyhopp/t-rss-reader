//
//  ListActionsView.swift
//  TRssReader
//
//  Created by Ty Hopp on 20/4/23.
//

import SwiftUI

struct ListActionsView: View {
    @EnvironmentObject var feedsStore: FeedsStore
    @EnvironmentObject var selectedFeedStore: SelectedFeedStore
    @EnvironmentObject var modalStore: ModalStore
    
    @State private var actionInFlight: Bool = false
    @State private var actionFailed: Bool = false
    
    let feedsService: FeedsService
    
    init(feedsService: FeedsService = FeedsService()) {
        self.feedsService = feedsService
    }
    
    func deleteFeed(url: String) {
        Task {
            do {
                actionInFlight = true
                
                let (_, deletedFeedResponse) = try await feedsService.deleteFeed(url: url)
                
                guard deletedFeedResponse.statusCode() == 200 else {
                    actionInFlight = false
                    actionFailed = true
                    return
                }
                
                feedsStore.deleteFeedByUrl(url: url)
                selectedFeedStore.feedUrl = nil
                actionInFlight = false
            } catch {
                actionInFlight = false
                actionFailed = true
            }
        }
    }
    
    var body: some View {
        if let feeds = feedsStore.feeds {
            if feeds.isEmpty {
                Text("No feeds yet")
            } else {
                List(selection: $selectedFeedStore.feedUrl) {
                    ForEach(feeds, id: \.url) { feed in
                        ListItemView(feed: feed)
                            .swipeActions(allowsFullSwipe: false) {
                                ActionButtonView(type: .edit) {
                                    modalStore.open(mode: .edit, name: feed.name, url: feed.url)
                                }
                                ActionButtonView(type: .delete) {
                                    deleteFeed(url: feed.url)
                                }
                            }
                            .contextMenu {
                                ActionButtonView(type: .edit) {
                                    modalStore.open(mode: .edit, name: feed.name, url: feed.url)
                                }
                                ActionButtonView(type: .delete) {
                                    deleteFeed(url: feed.url)
                                }
                            }
                    }
                    .deleteDisabled(actionInFlight)
                }
                .toolbar {
                    ToolbarItemGroup {
                        Spacer()
                        Button {
                            modalStore.open()
                        } label: {
                            Label("Add", systemImage: "plus.circle")
                        }
                    }
                }
                .alert("Request failed", isPresented: $actionFailed, actions: {
                    Button("Close") {
                        actionFailed = false
                    }
                })
            }
        } else {
            Text("No feeds yet")
        }
    }
}

#Preview("Feeds") {
    let feedsStore = FeedsStore()
    let selectedFeedStore = SelectedFeedStore()

    feedsStore.feeds = [
        Feed(name: "Feed 1", url: "https://example.com/feed1", createdAt: Date().nowInMs),
        Feed(name: "Feed 2", url: "https://example.com/feed2", createdAt: Date().nowInMs)
    ]

    selectedFeedStore.feedUrl = "https://example.com/feed1"

    return ListActionsView()
        .environmentObject(feedsStore)
        .environmentObject(selectedFeedStore)
        .environmentObject(ModalStore())
}

#Preview("No feeds") {
    ListActionsView()
        .environmentObject(FeedsStore())
        .environmentObject(SelectedFeedStore())
        .environmentObject(ModalStore())
}
