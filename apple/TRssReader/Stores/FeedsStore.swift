//
//  FeedsStore.swift
//  TRssReader
//
//  Created by Ty Hopp on 17/4/23.
//

import Foundation

protocol FeedsStorable {
    var feeds: [Feed]? { get set }
    
    func getFeedsUrlIndex() -> [String: Feed]
    
    func getFeedByUrl(url: String) -> Feed?
    
    func deleteFeedByUrl(url: String)
    
    func setFeeds(_ newFeeds: [Feed])
}

final class FeedsStore: FeedsStorable, ObservableObject {
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
    
    func setFeeds(_ newFeeds: [Feed]) {
        feeds = newFeeds
    }
}
