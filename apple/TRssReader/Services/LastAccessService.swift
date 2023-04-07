//
//  LastAccessService.swift
//  TRssReader
//
//  Created by Ty Hopp on 7/4/23.
//

import Foundation

class LastAccessService: AuthorizedService {
    @Sendable func putLastAccess() async throws -> (Data, URLResponse) {
        var request = URLRequest(url: URL(string: Env.LAST_ACCESS_API)!)
        
        request.httpMethod = "PUT"
        
        return try await URLSession.shared.data(for: request)
    }
}
