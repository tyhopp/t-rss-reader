//
//  AuthorizedServiceTests.swift
//  TRssReaderTests
//
//  Created by Ty Hopp on 3/4/23.
//

import XCTest
@testable import TRssReader

let mockToken: Token = Token(accessToken: "token", tokenType: "jwt", expiresIn: "0")

class AuthorizedServiceTests: XCTestCase {
    func testHeadersNoToken() {
        let service = AuthorizedService(keychain: MockedKeychainNoToken())
        XCTAssertEqual(service.headers(), service.defaultHeaders)
    }
    
    func testHeadersWithToken() {
        let service = AuthorizedService(keychain: MockedKeychainWithToken())
        var headers = service.headers()
        
        if let authorization = headers.removeValue(forKey: "Authorization") {
            XCTAssertTrue(authorization.contains(/accessToken/))
            XCTAssertEqual(headers, service.defaultHeaders)
        }
    }
    
    func testRequestNoToken() {
        let service = AuthorizedService(keychain: MockedKeychainNoToken())
        
        let api = "https://example.com"
        let request = service.request(api: api)
        
        XCTAssertEqual(request.url?.absoluteString, api)
        XCTAssertEqual(request.allHTTPHeaderFields, service.defaultHeaders)
    }
    
    func testRequestWithToken() {
        let service = AuthorizedService(keychain: MockedKeychainWithToken())
        
        let api = "https://example.com"
        let request = service.request(api: api)
        var headers = request.allHTTPHeaderFields
        
        XCTAssertEqual(request.url?.absoluteString, api)
        
        if let authorization = headers?.removeValue(forKey: "Authorization") {
            XCTAssertTrue(authorization.contains(/accessToken/))
            XCTAssertEqual(headers, service.defaultHeaders)
        }
    }
}

private class MockedKeychainNoToken: Keychain {
    override func getToken() -> AnyObject? {
        return [String: String]() as AnyObject
    }
}

private class MockedKeychainWithToken: Keychain {
    override func getToken() -> AnyObject? {
        return try? JSONEncoder().encode(mockToken) as AnyObject
    }
}
