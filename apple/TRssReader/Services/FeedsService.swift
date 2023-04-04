//
//  FeedsService.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation

class FeedsService: AuthorizedService {
    @Sendable func deleteFeed(url: String) async {
        do {
            var request = self.request(api: Env.FEEDS_API)
            
            request.httpMethod = "DELETE"
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print(String(data: data, encoding: .utf8) as Any)
        } catch {
            print(error)
        }
    }
}
