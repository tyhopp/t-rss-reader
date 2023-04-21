//
//  DetailsViewModel.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

struct DetailsViewModel {
    var feedsStore: FeedsStorable
    var selectedFeedStore: SelectedFeedStorable
    var entriesService: EntriesService
    
    init(
        feedsStore: FeedsStorable = FeedsStore(),
        selectedFeedStore: SelectedFeedStorable = SelectedFeedStore(),
        entriesService: EntriesService = EntriesService()
    ) {
        self.feedsStore = feedsStore
        self.selectedFeedStore = selectedFeedStore
        self.entriesService = entriesService
    }
    
    enum DetailsViewModelError: Error {
        case entriesRequest
        case entriesDecode
        case noSelectedFeed
        case unknown
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
    
    func getEntries() async -> Result<[Entry], Error> {
        do {
            if let selectedFeedUrl = selectedFeedStore.feedUrl {
                let (entriesData, entriesResponse) = try await entriesService.getEntries(url: selectedFeedUrl)
                
                guard let entries = try? JSONDecoder().decode([Entry].self, from: entriesData) else {
                    return .failure(DetailsViewModelError.entriesDecode)
                }
                
                guard entriesResponse.statusCode() == 200 else {
                    return .failure(DetailsViewModelError.entriesRequest)
                }
                
                return .success(entries)
            } else {
                return .failure(DetailsViewModelError.noSelectedFeed)
            }
        } catch {
            return .failure(DetailsViewModelError.unknown)
        }
    }
}
