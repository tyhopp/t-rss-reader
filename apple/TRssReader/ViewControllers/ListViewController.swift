//
//  ListViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListViewController: View {
    @EnvironmentObject var feedsModelController: FeedsModelController
    
    @ViewBuilder var body: some View {
        switch feedsModelController.result {
        case .none:
            // TODO: Proper loading indicator
            Text("Loading")
            
        case .failure(_):
            Text("Failed to get feeds")
            // TODO: Retry logic
            
        case .success(let feeds):
            if feeds.isEmpty {
                Text("No feeds yet")
                // TODO: Add feed button
            } else {
                List(feeds, id: \.url) { feed in
                    NavigationLink(feed.name, destination: DetailsViewController(selectedFeed: feed))
                }
            }
        }
    }
}

struct ListViewController_Previews: PreviewProvider {
    class MockedFeedsServiceSuccess: FeedsService {
        @Sendable override func getFeeds() async throws -> (Data, URLResponse) {
            let feeds: [Feed] = [
                Feed(name: "A", url: "https://a.com", createdAt: 0),
                Feed(name: "B", url: "https://b.com", createdAt: 0),
                Feed(name: "C", url: "https://c.com", createdAt: 0)
            ]
            
            let feedsEncoded = try JSONEncoder().encode(feeds)
            
            guard let url = URL(string: "https://example.com") else {
                throw FeedsModelError.feedsRequest
            }
            
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1", headerFields: [:]) else { throw FeedsModelError.feedsRequest }
            
            return (feedsEncoded, response)
        }
    }
    
    class MockedFeedsServiceEmpty: FeedsService {
        @Sendable override func getFeeds() async throws -> (Data, URLResponse) {
            let feeds: [Feed] = []
            
            let feedsEncoded = try JSONEncoder().encode(feeds)
            
            guard let url = URL(string: "https://example.com") else {
                throw FeedsModelError.feedsRequest
            }
            
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1", headerFields: [:]) else { throw FeedsModelError.feedsRequest }
            
            return (feedsEncoded, response)
        }
    }
    
    class MockedFeedsServiceFailure: FeedsService {
        @Sendable override func getFeeds() async throws -> (Data, URLResponse) {
            return (Data(), URLResponse())
        }
    }
    
    static var previews: some View {
        Group {
            ListViewController()
                .environmentObject(FeedsModelController(feedsService: MockedFeedsServiceSuccess()))
                .previewDisplayName("ListViewController - Success")
            
            ListViewController()
                .environmentObject(FeedsModelController(feedsService: MockedFeedsServiceEmpty()))
                .previewDisplayName("ListViewController - Empty")
            
            ListViewController()
                .environmentObject(FeedsModelController(feedsService: MockedFeedsServiceFailure()))
                .previewDisplayName("ListViewController - Failure")
        }
    }
}
