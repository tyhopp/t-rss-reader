//
//  DetailsViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct DetailsViewController: View {
    var selectedFeed: Feed
    var entriesService: EntriesService
    
    @State private var result: Result<[Entry], Error>?
    
    enum DetailsViewControllerError: Error {
        case entriesRequest
        case entriesDecode
    }
    
    init(selectedFeed: Feed, entriesService: EntriesService = EntriesService()) {
        self.selectedFeed = selectedFeed
        self.entriesService = entriesService
    }
    
    @ViewBuilder var body: some View {
        Group {
            switch result {
            case .none:
                ProgressView()
                
            case .failure(_):
                Text("Failed to get entries")
                
            case .success(let entries):
                if entries.isEmpty {
                    Text("Select a feed to view entries")
                    // TODO: Select random button
                } else {
                    List(entries, id: \.url) { entry in
                        // TODO: DetailsItemView
                        Text(entry.title)
                    }
                }
            }
        }
        .navigationTitle(selectedFeed.name.isEmpty ? "Entries" : selectedFeed.name)
        .task { @MainActor in
            do {
                let (entriesData, entriesResponse) = try await entriesService.getEntries(url: selectedFeed.url)
                
                guard let entries = try? JSONDecoder().decode([Entry].self, from: entriesData) else {
                    result = .failure(DetailsViewControllerError.entriesDecode)
                    return
                }
                
                guard entriesResponse.statusCode() == 200 else {
                    result = .failure(DetailsViewControllerError.entriesRequest)
                    return
                }
                
                result = .success(entries)
            } catch {
                result = .failure(DetailsViewControllerError.entriesRequest)
            }
        }
    }
}

struct DetailsViewController_Previews: PreviewProvider {
    static let feed: Feed = Feed(name: "A", url: "https://a.com", createdAt: 0)
    
    static var previews: some View {
        DetailsViewController(selectedFeed: feed, entriesService: EntriesService())
    }
}
