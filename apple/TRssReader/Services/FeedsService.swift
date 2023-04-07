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
        var request = URLRequest(url: URL(string: Env.FEEDS_API)!)
        
        request.httpMethod = "GET"
        
        return try await URLSession.shared.data(for: request)
    }
    
    @Sendable func putFeed(url: String, name: String) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: URL(string: Env.FEEDS_API)!)
        
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(["url": url, "name": name])
        } catch {
            throw ServiceError.encodeBody
        }
        
        return try await URLSession.shared.data(for: request)
    }
}
