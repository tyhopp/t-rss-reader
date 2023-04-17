//
//  FeedsModelController.swift
//  TRssReader
//
//  Created by Ty Hopp on 17/4/23.
//

import Foundation

enum FeedsModelError: Error {
    case feedsRequest
    case feedsDecode
}

protocol FeedsModelControllable {
    var result: Result<[Feed], Error>? { get set }
}

final class FeedsModelController: FeedsModelControllable, ObservableObject {
    @Published var result: Result<[Feed], Error>?
    
    private let feedsService: FeedsService

    init(feedsService: FeedsService = FeedsService()) {
        self.feedsService = feedsService
        
        Task {
            do {
                let (feedsData, feedsResponse) = try await feedsService.getFeeds()
                
                guard let feeds = try? JSONDecoder().decode([Feed].self, from: feedsData) else {
                    result = .failure(FeedsModelError.feedsDecode)
                    return
                }
                
                guard feedsResponse.statusCode() == 200 else {
                    result = .failure(FeedsModelError.feedsRequest)
                    return
                }
                
                // TODO: Investigate using receive(on:) API to not make UI-mutating changes from a background thread
                result = .success(feeds)
            } catch {
                result = .failure(FeedsModelError.feedsRequest)
            }
        }
    }
}
