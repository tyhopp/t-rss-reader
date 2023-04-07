//
//  ServiceError.swift
//  TRssReader
//
//  Created by Ty Hopp on 7/4/23.
//

enum ServiceError: Error {
    case url
    case accessToken
    case headers
    case encodeBody
}
