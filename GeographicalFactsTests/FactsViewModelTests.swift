//
//  FactsViewModelTests.swift
//  GeographicalFactsTests
//
//  Created by 273490 on 01/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import XCTest
@testable import GeographicalFacts

class FactsViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    override func setUp() {
        viewModel = ViewModel()
    }

    override func tearDown() {
        
    }

    //This test case will be passed if the facts JSON is fetched successfully
    func testFetchFactJSONSuccessCall() {
        let successWaitExpectation = expectation(description: "FactsJSONFetchSuccess")
        viewModel.fetchFacts(ServiceUrls.factsFetchUrl, { (result) in
            switch result {
            case .success:
                successWaitExpectation.fulfill()
            default:
                break
            }
        })
        self.waitForExpectations(timeout: 10) { (err) in
            if let error = err {
                print("Error: \(error.localizedDescription)")
                XCTAssertTrue(false, "Facts JSON fetch timeout")
            }
        }
    }
    //This test case will be passed if the facts JSON is not fetched as the url is wrong
    func testFetchFactJSONFailureCall() {
        let failWaitExpectation = expectation(description: "FactsJSONFetchFail")
        viewModel.fetchFacts(TestDataFetchUrl.badJSONUrl, { (result) in
            switch result {
            case .failure:
                failWaitExpectation.fulfill()
            default:
                break
            }
        })
        self.waitForExpectations(timeout: 10) { (err) in
            if let error = err {
                print("ERROR: \(error.localizedDescription)")
                XCTAssertTrue(false, "Facts JSON fetch timeout")
            }
        }
    }
    //Check for valid fact data, that is, if all the values are nil it is not a valid fact
    func testFactDataCheckForValidRows() {
        let beaversFact = Fact(title: "Beavers", description: "desc", imageHref: "link")
        let emptyFact = Fact(title: nil, description: nil, imageHref: nil)
        let factDataModel = FactData(title: "Canada",
                                     rows: [beaversFact, emptyFact])
        viewModel.factData = factDataModel
        viewModel.checkForValidFactData(data: viewModel.factData)
        XCTAssertEqual(viewModel.factData.rows?.count, 1)
    }
}
