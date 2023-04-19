//
//  FeedsModelController.swift
//  TRssReader
//
//  Created by Ty Hopp on 17/4/23.
//

import Foundation

final class FeedsModelController: ObservableObject {
    static let shared = FeedsModelController()
    
    @Published var feeds: [Feed]?
    
    private init() {}
    
    func getFeedsUrlIndex() -> [String: Feed] {
        var feedsByUrl = [String: Feed]()
        
        if let feeds = feeds {
            for feed in feeds {
                feedsByUrl[feed.url] = feed
            }
        }
        
        return feedsByUrl
    }
    
    func getFeedWithUrl(url: String) -> Feed? {
        let feedsUrlIndex = getFeedsUrlIndex()
        return feedsUrlIndex[url]
    }
}
