//
//  Entry.swift
//  TRssReader
//
//  Created by Ty Hopp on 18/4/23.
//

struct Entry: Codable {
    var url: String
    var title: String
    var published: String
    var isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case url, title, published, isNew
    }
}
