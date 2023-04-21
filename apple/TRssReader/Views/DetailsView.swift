//
//  DetailsView.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    @State private var task: Task<Void, Error>?
    @State private var result: Result<[Entry], Error>?
    
    private var detailsViewModel = DetailsViewModel()
    
    @ViewBuilder var body: some View {
        Group {
            switch result {
            case .none:
                if detailsViewModel.selectedFeedStore.feedUrl != nil {
                    ProgressView()
                }
            case .failure(_):
                Text("Failed to get entries")
            case .success(let entries):
                if entries.isEmpty {
                    Text("Select a feed to view entries")
                    // TODO: Select random button
                } else {
                    List(entries, id: \.url) { entry in
                        DetailsItemView(entry: entry)
                    }
                }
            }
        }
        .navigationTitle(detailsViewModel.getNavigationTitle())
        .onChange(of: detailsViewModel.selectedFeedStore.feedUrl) { selectedFeedUrl in
            result = .none
            task?.cancel()
            
            Task { @MainActor in
                task = Task {
                    result = await detailsViewModel.getEntries()
                }
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
