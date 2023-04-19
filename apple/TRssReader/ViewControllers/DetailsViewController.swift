//
//  DetailsViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct DetailsViewController: View {
    @EnvironmentObject var feedsModelController: FeedsModelController
    @Binding var selectedFeedUrl: String?
    @State private var task: Task<Void, Error>?
    @State private var result: Result<[Entry], Error>?
    
    var entriesService: EntriesService
    
    enum DetailsViewControllerError: Error {
        case entriesRequest
        case entriesDecode
    }
    
    init(entriesService: EntriesService = EntriesService(), selectedFeedUrl: Binding<String?>) {
        self.entriesService = entriesService
        _selectedFeedUrl = selectedFeedUrl
    }
    
    func getNavigationTitle() -> String {
        guard let selectedFeedUrl = selectedFeedUrl else {
            return "Entries"
        }
        
        let selectedFeed = feedsModelController.getFeedByUrl(url: selectedFeedUrl)
        
        if let name = selectedFeed?.name {
            return name
        }
        
        return "Entries"
    }
    
    func getEntries() async {
        task = Task {
            if let selectedFeedUrl = selectedFeedUrl {
                let (entriesData, entriesResponse) = try await entriesService.getEntries(url: selectedFeedUrl)
                
                guard let entries = try? JSONDecoder().decode([Entry].self, from: entriesData) else {
                    result = .failure(DetailsViewControllerError.entriesDecode)
                    return
                }
                
                guard entriesResponse.statusCode() == 200 else {
                    result = .failure(DetailsViewControllerError.entriesRequest)
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
                if selectedFeedUrl != nil {
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
        .navigationTitle(getNavigationTitle())
        .onChange(of: selectedFeedUrl) { selectedFeedUrl in
            result = .none
            task?.cancel()
            
            Task { @MainActor in
                await getEntries()
            }
        }
    }
}

struct DetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreview(stateVariable: "https://example.com") { binding in
            DetailsViewController(entriesService: EntriesService(), selectedFeedUrl: binding)
        }
    }
}
