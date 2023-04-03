//
//  Feed.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation

struct Feed: Codable {
    var name: String
    var url: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case name, url, createdAt
    }
}
