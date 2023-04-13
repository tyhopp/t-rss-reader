//
//  Date+nowInt.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation

extension Date {
    var nowInMs: Int {
        return Int((Date().timeIntervalSince1970) * 1000)
    }
}
