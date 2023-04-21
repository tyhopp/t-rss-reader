//
//  ListView.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListView: View {
    @State private var result: Result<Bool, Error>?
    
    private var listViewModel: ListViewModel
    
    init(listViewModel: ListViewModel = ListViewModel()) {
        self.listViewModel = ListViewModel()
    }
    
    @ViewBuilder var body: some View {
        Group {
            switch result {
            case .none:
                ProgressView()
            case .failure(_):
                Text("Failed to get feeds")
                // TODO: Retry logic
            case .success(_):
                if let feeds = listViewModel.feedsStore.feeds {
                    if feeds.isEmpty {
                        Text("No feeds yet")
                    } else {
                        ListActionsView()
                    }
                } else {
                    Text("No feeds yet")
                }
            }
        }
        .task {
            if case .none = result {
                result = await listViewModel.getFeeds()
            }
        }
    }
}
