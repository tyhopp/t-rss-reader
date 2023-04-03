//
//  Token.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation

struct Token: Codable {
    var accessToken: String
    var tokenType: String
    var expiresIn: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken, tokenType, expiresIn
    }
}
