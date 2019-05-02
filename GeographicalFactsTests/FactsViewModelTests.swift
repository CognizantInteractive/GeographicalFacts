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
    var factsFileManager: FactsFileManager!
    override func setUp() {
        viewModel = ViewModel()
        factsFileManager = FactsFileManager()
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
    
    //This test case will be passed if the fact image is downloaded successfully
    func testGetFactImageSuccessCall() {
        //calling deleteImagesFolder() to delete all the images which are downloaded and saved
        factsFileManager.deleteImagesFolder()
        let successWaitExpectation = expectation(description: "FactsImageDownloadSuccess")
        viewModel.getImageData(ImageUrls.imageDownloadSuccessUrl, {(result) in
            switch result {
            case .success:
                successWaitExpectation.fulfill()
            default:
                break
            }
        })
        self.waitForExpectations(timeout: 30) { (err) in
            if let error = err {
                print("Error: \(error.localizedDescription)")
                XCTAssertTrue(false, "Facts image download timeout")
            }
        }
    }
    //This test case will be passed if the fact image is not downloaded as its wrong url
    func testGetFactImageFailureCall() {
        let failureWaitExpectation = expectation(description: "FactsImageDownloadFail")
        viewModel.getImageData(ImageUrls.imageDownloadFailUrl, {(result) in
            switch result {
            case .failure:
                failureWaitExpectation.fulfill()
            default:
                break
            }
        })
        self.waitForExpectations(timeout: 30) { (err) in
            if let error = err {
                print("Error: \(error.localizedDescription)")
                XCTAssertTrue(false, "Facts image download timeout")
            }
        }
    }
}
