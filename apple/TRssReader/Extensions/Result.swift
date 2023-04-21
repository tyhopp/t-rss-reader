//
//  Result.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

extension Result {
    var succeeded: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }

    var failed: Bool {
        return !succeeded
    }
}
