//
//  KeychainKey.swift
//  TRssReader
//
//  Created by Ty Hopp on 4/4/23.
//

import Foundation
import Keychain

enum KeychainKey {
    @Keychain(service: "t-rss-reader-access-token", account: "t-rss-reader") static public var token: String?
}
