//
//  URLResponse+statusCode.swift
//  TRssReader
//
//  Created by Ty Hopp on 7/4/23.
//

import Foundation

extension URLResponse {
    func statusCode() -> Int {
        if let code = (self as? HTTPURLResponse)?.statusCode {
            return code
        } else {
            return 500
        }
    }
}
