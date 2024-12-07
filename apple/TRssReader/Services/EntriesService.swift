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

#if DEBUG
class MockEntriesService: EntriesService {
    @Sendable override func getEntries(url: String) async throws -> (Data, URLResponse) {
        let sampleEntries: [Entry] = [
            Entry(url: "https://example.com/entry1", title: "Entry 1", published: Date().ISO8601Format(), isNew: false),
            Entry(url: "https://example.com/entry2", title: "Entry 2", published: Date().ISO8601Format(), isNew: true),
            Entry(url: "https://example.com/entry3", title: "Entry 3", published: Date().ISO8601Format(), isNew: false)
        ]
        
        let data = try JSONEncoder().encode(sampleEntries)
        
        let response = HTTPURLResponse(
            url: URL(string: url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (data, response)
    }
}
#endif
