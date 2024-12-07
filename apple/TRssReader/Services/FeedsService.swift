//
//  FeedsService.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation

class FeedsService: AuthorizedService {
    @Sendable func deleteFeed(url: String) async throws -> (Data, URLResponse) {
        var request = try self.request(api: Env.FEEDS_API)
        
        request.httpMethod = "DELETE"
        
        do {
            request.httpBody = try JSONEncoder().encode(["url": url])
        } catch {
            throw ServiceError.encodeBody
        }
        
        return try await URLSession.shared.data(for: request)
    }
    
    @Sendable func getFeeds() async throws -> (Data, URLResponse) {
        var request = try self.request(api: Env.FEEDS_API)
        
        request.httpMethod = "GET"
        
        return try await URLSession.shared.data(for: request)
    }
    
    @Sendable func putFeed(url: String, name: String) async throws -> (Data, URLResponse) {
        var request = try self.request(api: Env.FEEDS_API)
        
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(["url": url, "name": name])
        } catch {
            throw ServiceError.encodeBody
        }
        
        return try await URLSession.shared.data(for: request)
    }
}

#if DEBUG
class MockFeedsService: FeedsService {
    @Sendable override func deleteFeed(url: String) async throws -> (Data, URLResponse) {
        let data = try JSONEncoder().encode(["success": true])
        let response = HTTPURLResponse(url: URL(string: Env.FEEDS_API)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
    
    @Sendable override func getFeeds() async throws -> (Data, URLResponse) {
        let sampleFeeds = [
            Feed(name: "Feed 1", url: "https://example.com/feed1", createdAt: Date().nowInMs),
            Feed(name: "Feed 2", url: "https://example.com/feed2", createdAt: Date().nowInMs)
        ]
        
        let data = try JSONEncoder().encode(sampleFeeds)
        let response = HTTPURLResponse(url: URL(string: Env.FEEDS_API)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
    
    @Sendable override func putFeed(url: String, name: String) async throws -> (Data, URLResponse) {
        let feed = Feed(name: name, url: url, createdAt: Date().nowInMs)
        let data = try JSONEncoder().encode(feed)
        let response = HTTPURLResponse(url: URL(string: Env.FEEDS_API)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
}
#endif
