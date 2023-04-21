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
    @EnvironmentObject var modalModelController: ModalModelController
    
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
                
                feedsModelController.deleteFeedByUrl(url: url)
                selectedFeedModelController.feedUrl = nil
                actionInFlight = false
            } catch {
                actionInFlight = false
                actionFailed = true
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
                            .swipeActions(allowsFullSwipe: false) {
                                ActionButtonView(buttonType: .edit) {
                                    modalModelController.open(mode: .edit, name: feed.name, url: feed.url)
                                }
                                ActionButtonView(buttonType: .delete) {
                                    deleteFeed(url: feed.url)
                                }
                            }
                            .contextMenu {
                                ActionButtonView(buttonType: .edit) {
                                    modalModelController.open(mode: .edit, name: feed.name, url: feed.url)
                                }
                                ActionButtonView(buttonType: .delete) {
                                    deleteFeed(url: feed.url)
                                }
                            }
                    }
                    .deleteDisabled(actionInFlight)
                }
                .toolbar {
                    ToolbarItemGroup {
                        Spacer()
                        Button("Add") {
                            print("TODO: Add")
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

struct ListActionsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListActionsViewController()
    }
}
