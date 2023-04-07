//
//  EntriesService.swift
//  TRssReader
//
//  Created by Ty Hopp on 7/4/23.
//

import Foundation

class EntriesService: AuthorizedService {
    @Sendable func getEntries(url: String) async throws -> (Data, URLResponse) {
        var request = try self.request(api: Env.ENTRIES_API, queryItems: [URLQueryItem(name: "url", value: url)])
        
        request.httpMethod = "GET"
        
        return try await URLSession.shared.data(for: request)
    }
}
