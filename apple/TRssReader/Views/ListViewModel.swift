//
//  ListViewModel.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

struct ListViewModel {
    var feedsService: FeedsService
    var feedsStore: FeedsStorable
    
    init(feedsService: FeedsService = FeedsService(), feedsStore: FeedsStorable = FeedsStore()) {
        self.feedsService = feedsService
        self.feedsStore = feedsStore
    }
    
    enum ListViewModelError: Error {
        case feedsRequest
        case feedsDecode
    }
    
    func getFeeds() async -> Result<Bool, Error> {
        do {
            let (feedsData, feedsResponse) = try await feedsService.getFeeds()
            
            guard let feeds = try? JSONDecoder().decode([Feed].self, from: feedsData) else {
                return .failure(ListViewModelError.feedsDecode)
            }
            
            guard feedsResponse.statusCode() == 200 else {
                return .failure(ListViewModelError.feedsRequest)
            }
            
            feedsStore.setFeeds(feeds)
            
            return .success(true)
        } catch {
            return .failure(ListViewModelError.feedsRequest)
        }
    }
}
