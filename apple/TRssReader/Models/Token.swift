//
//  Token.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

struct Token: Codable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken, tokenType, expiresIn
    }
}
