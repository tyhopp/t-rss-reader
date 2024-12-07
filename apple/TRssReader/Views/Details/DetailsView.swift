//
//  DetailsView.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var feedsStore: FeedsStore
    @EnvironmentObject var selectedFeedStore: SelectedFeedStore
    
    @State private var task: Task<Void, Error>?
    @State private var result: Result<[Entry], Error>?
    
    var entriesService: EntriesService
    
    enum DetailsViewError: Error {
        case entriesRequest
        case entriesDecode
    }
    
    init(entriesService: EntriesService = EntriesService()) {
        self.entriesService = entriesService
    }
    
    func getNavigationTitle() -> String {
        guard let selectedFeedUrl = selectedFeedStore.feedUrl else {
            return "Entries"
        }
        
        let selectedFeed = feedsStore.getFeedByUrl(url: selectedFeedUrl)
        
        if let name = selectedFeed?.name {
            return name
        }
        
        return "Entries"
    }
    
    func getEntries() async {
        task = Task {
            if let selectedFeedUrl = selectedFeedStore.feedUrl {
                let (entriesData, entriesResponse) = try await entriesService.getEntries(url: selectedFeedUrl)
                
                guard let entries = try? JSONDecoder().decode([Entry].self, from: entriesData) else {
                    result = .failure(DetailsViewError.entriesDecode)
                    return
                }
                
                guard entriesResponse.statusCode() == 200 else {
                    result = .failure(DetailsViewError.entriesRequest)
                    return
                }
                
                result = .success(entries)
            }
        }
    }
    
    @ViewBuilder var body: some View {
        Group {
            switch result {
            case .none:
                if selectedFeedStore.feedUrl != nil {
                    ProgressView()
                }
            case .failure(_):
                Text("Failed to get entries")
            case .success(let entries):
                if entries.isEmpty {
                    Text("Select a feed to view entries")
                    // TODO: Select random button
                } else {
                    #if os(iOS)
                    Spacer()
                        .frame(height: 10)
                    #endif
                    List(entries, id: \.url) { entry in
                        DetailsItemView(entry: entry)
                    }
                }
            }
        }
        .navigationTitle(getNavigationTitle())
        .onAppear {
            Task { @MainActor in
                await getEntries()
            }
        }
        .onChange(of: selectedFeedStore.feedUrl) { _, _ in
            result = .none
            task?.cancel()
            
            Task { @MainActor in
                await getEntries()
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
    
    return DetailsView(entriesService: MockEntriesService())
        .environmentObject(feedsStore)
        .environmentObject(selectedFeedStore)
}
