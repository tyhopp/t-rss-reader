//
//  Env.swift
//  TRssReader
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation

enum Env {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let FEEDS_API: String = {
        guard let apiKey = Env.infoDictionary["FEEDS_API"] as? String else {
            fatalError("FEEDS_API key not set in plist")
        }
        return apiKey
    }()
    
    static let LOGIN_API: String = {
        guard let apiKey = Env.infoDictionary["LOGIN_API"] as? String else {
            fatalError("LOGIN_API key not set in plist")
        }
        return apiKey
    }()
    
    static let ENTRIES_API: String = {
        guard let apiKey = Env.infoDictionary["ENTRIES_API"] as? String else {
            fatalError("ENTRIES_API key not set in plist")
        }
        return apiKey
    }()
    
    static let LAST_ACCESS_API: String = {
        guard let apiKey = Env.infoDictionary["LAST_ACCESS_API"] as? String else {
            fatalError("LAST_ACCESS_API key not set in plist")
        }
        return apiKey
    }()
}
