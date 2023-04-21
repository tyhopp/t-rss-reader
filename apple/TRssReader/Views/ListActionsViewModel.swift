//
//  ListActionsViewModel.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

struct ListActionsViewModel {
    var feedsService: FeedsService
    var feedsStore: FeedsStorable
    
    init(feedsService: FeedsService = FeedsService(), feedsStore: FeedsStorable = FeedsStore()) {
        self.feedsService = feedsService
        self.feedsStore = feedsStore
    }
    
    enum ListActionsViewModelError: Error {
        case deleteFeedRequest
    }
    
    func deleteFeed(url: String) async -> Result<Bool, Error> {
        do {
            let (_, deletedFeedResponse) = try await feedsService.deleteFeed(url: url)
            
            guard deletedFeedResponse.statusCode() == 200 else {
                return .failure(ListActionsViewModelError.deleteFeedRequest)
            }
            
            feedsStore.deleteFeedByUrl(url: url)
            
            return .success(true)
        } catch {
            return .failure(ListActionsViewModelError.deleteFeedRequest)
        }
    }
}
