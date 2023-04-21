//
//  ListActionsView.swift
//  TRssReader
//
//  Created by Ty Hopp on 20/4/23.
//

import SwiftUI

struct ListActionsView: View {
    @State private var selectedFeedStore: SelectedFeedStorable = SelectedFeedStore()
    @State private var modalStore: ModalStorable = ModalStore()
    @State private var result: Result<Bool, Error>?
    @State private var inFlight: Bool = false
    
    private var listActionsViewModel: ListActionsViewModel
    
    init(
        listActionsViewModel: ListActionsViewModel = ListActionsViewModel(),
        selectedFeedStore: SelectedFeedStorable = SelectedFeedStore(),
        modalStore: ModalStorable = ModalStore()
    ) {
        self.listActionsViewModel = listActionsViewModel
        self.selectedFeedStore = selectedFeedStore
        self.modalStore = modalStore
    }
    
    @ViewBuilder var body: some View {
        List(selection: $selectedFeedStore.feedUrl) {
            ForEach(listActionsViewModel.feedsStore.feeds ?? [], id: \.url) { feed in
                ListItemView(feed: feed)
                    .swipeActions(allowsFullSwipe: false) {
                        ListActionButtonView(type: .edit) {
                            modalStore.open(mode: .edit, name: feed.name, url: feed.url)
                        }
                        ListActionButtonView(type: .delete) {
                            Task {
                                inFlight = true
                                result = await listActionsViewModel.deleteFeed(url: feed.url)
                                if case .success = result {
                                    selectedFeedStore.feedUrl = nil
                                }
                                inFlight = false
                            }
                        }
                    }
                    .contextMenu {
                        // TODO: DRY
                        ListActionButtonView(type: .edit) {
                            modalStore.open(mode: .edit, name: feed.name, url: feed.url)
                        }
                        ListActionButtonView(type: .delete) {
                            Task {
                                inFlight = true
                                result = await listActionsViewModel.deleteFeed(url: feed.url)
                                if case .success = result {
                                    selectedFeedStore.feedUrl = nil
                                }
                                inFlight = false
                            }
                        }
                    }
            }
            .deleteDisabled(inFlight)
        }
        .toolbar {
            ToolbarItemGroup {
                Spacer()
                Button {
                    modalStore.open(mode: .add, name: nil, url: nil)
                } label: {
                    Label("Add", systemImage: "plus.circle")
                }
            }
        }
//        .alert("Request failed", isPresented: result?.succeeded, actions: {
//            Button("Close") {
//                result = nil
//            }
//        })
    }
}

struct ListActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ListActionsView()
    }
}
