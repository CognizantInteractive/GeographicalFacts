//
//  GeographicalFactsTests.swift
//  GeographicalFactsTests
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import XCTest
@testable import GeographicalFacts

class FactsNetworkingTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    //success network call for facts JSON download
    func testNetworkingSuccessCall() {
        let successWaitExpectation = expectation(description: "NetworkingSuccessCall")
        NetworkManager.getFactJSONData(ServiceUrls.factsFetchUrl) { (result) in
            switch result {
            case .success:
                successWaitExpectation.fulfill()
            default:
                break
            }
        }
        self.waitForExpectations(timeout: 10) { (err) in
            if let error = err {
                print("ERROR: \(error.localizedDescription)")
                XCTAssertTrue(false, "Network timeout")
            }
        }
    }
    
    //failure network call for facts JSON download
    func testNetworkingFailureCall() {
        let failureWaitExpectation = expectation(description: "NetworkingFailureCall")
        NetworkManager.getFactJSONData(TestDataFetchUrl.badJSONUrl) { (result) in
            switch result {
            case .failure:
                failureWaitExpectation.fulfill()
            default:
                break
            }
        }
        self.waitForExpectations(timeout: 10) { (err) in
            if let error = err {
                print("ERROR: \(error.localizedDescription)")
                XCTAssertTrue(false, "Network timeout")
            }
        }
    }

}
