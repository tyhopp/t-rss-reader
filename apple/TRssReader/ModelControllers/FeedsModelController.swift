//
//  FeedsModelController.swift
//  TRssReader
//
//  Created by Ty Hopp on 17/4/23.
//

import Foundation

final class FeedsModelController: ObservableObject {
    @Published var feeds: [Feed]?
    
    func getFeedsUrlIndex() -> [String: Feed] {
        var feedsByUrl = [String: Feed]()
        
        if let feeds = feeds {
            for feed in feeds {
                feedsByUrl[feed.url] = feed
            }
        }
        
        return feedsByUrl
    }
    
    func getFeedByUrl(url: String) -> Feed? {
        let feedsUrlIndex = getFeedsUrlIndex()
        return feedsUrlIndex[url]
    }
    
    func deleteFeedByUrl(url: String) {
        feeds = feeds?.filter { $0.url != url }
    }
}
