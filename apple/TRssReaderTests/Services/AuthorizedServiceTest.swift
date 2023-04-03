//
//  AuthorizedServiceTest.swift
//  TRssReaderTests
//
//  Created by Ty Hopp on 3/4/23.
//

import Foundation
import XCTest

class AuthorizedServiceTest: XCTestCase {
    var service: AuthorizedService!

    override func setUp() {
        super.setUp()
        service = AuthorizedService()
    }

    func testToken() {
        XCTAssertNil(service.token)
    }
}
