//
//  AuthorizedServiceTests.swift
//  TRssReaderTests
//
//  Created by Ty Hopp on 3/4/23.
//

import XCTest
@testable import TRssReader

let mockToken: Token = Token(accessToken: "token", tokenType: "jwt", expiresIn: 0)

class AuthorizedServiceTests: XCTestCase {
    let api = "https://example.com"
    
    func testUrlFailure() {
        let service = AuthorizedService()
        
        XCTAssertErrorType(try service.url(api: ""), throws: ServiceError.url)
    }
    
    func testUrlSuccess() {
        let service = AuthorizedService()
    
        let url: URL
        
        do {
            url = try service.url(api: api)
            
            XCTAssertEqual(url.absoluteString, api)
        } catch {
            XCTFail("Failed to construct url")
        }
    }
    
    func testHeadersNoToken() {
        let service = AuthorizedService(keychain: MockedKeychainNoToken())
        
        XCTAssertErrorType(try service.headers(), throws: ServiceError.accessToken)
    }
    
    func testHeadersWithToken() {
        let service = AuthorizedService(keychain: MockedKeychainWithToken())
        
        var headers: [String: String]
        
        do {
            headers = try service.headers()
            
            if let authorization = headers.removeValue(forKey: "Authorization") {
                XCTAssertEqual(authorization, mockToken.accessToken)
                XCTAssertEqual(headers, service.defaultHeaders)
            }
        } catch {
            XCTFail("Failed to get headers with token")
        }
    }
    
    func testRequestNoToken() {
        let service = AuthorizedService(keychain: MockedKeychainNoToken())
        
        XCTAssertErrorType(try service.request(api: api), throws: ServiceError.headers)
    }
    
    func testRequestWithToken() {
        let service = AuthorizedService(keychain: MockedKeychainWithToken())
        
        let request: URLRequest
        
        do {
            request = try service.request(api: api)
            
            var headers = request.allHTTPHeaderFields
            
            XCTAssertEqual(request.url?.absoluteString, api)
            
            if let authorization = headers?.removeValue(forKey: "Authorization") {
                XCTAssertEqual(authorization, mockToken.accessToken)
                XCTAssertEqual(headers, service.defaultHeaders)
            }
        } catch {
            XCTFail("Failed to get request with token")
        }
    }
    
    func testRequestWithQueryItems() {
        let service = AuthorizedService(keychain: MockedKeychainWithToken())
        let queryItems = URLQueryItem(name: "a", value: "b")
        
        let request: URLRequest
        
        do {
            request = try service.request(api: api, queryItems: [queryItems])
            XCTAssertEqual(request.url?.absoluteString, "\(api)?a=b")
        } catch {
            XCTFail("Failed to get request with query items")
        }
    }
}

private class MockedKeychainNoToken: Keychain {
    override func getToken() -> Token? {
        return nil
    }
}

private class MockedKeychainWithToken: Keychain {
    override func getToken() -> Token? {
        return mockToken
    }
}
