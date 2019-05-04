//
//  FactsFileManagerTests.swift
//  GeographicalFactsTests
//
//  Created by 273490 on 02/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import XCTest
@testable import GeographicalFacts

class FactsFileManagerTests: XCTestCase {
    
    override func setUp() {
    }

    override func tearDown() {
        
    }
    
    //test for checking the Image folder path
    func testFactsImageFolderPath() {
        let fileManger = FileManager.default
        let dirPaths = fileManger.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheURL = dirPaths[0]
        let imageFolderPath = cacheURL.appendingPathComponent(FactImages.factImagesFolder).path + "/"
        XCTAssertEqual(FactsFileManager.fileManager.getTheFactsImageFolderPath(), imageFolderPath)
    }

    //This test case will be passed if the fact image is downloaded successfully
    func testGetFactImageSuccessCall() {
        //deleting the saved images folder before downloading the image
        FactsFileManager.fileManager.deleteImagesFolder()
        let successWaitExpectation = expectation(description: "FactsImageDownloadSuccess")
        FactsFileManager.fileManager.getImageData(ImageUrls.imageDownloadSuccessUrl, {(result) in
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
        FactsFileManager.fileManager.getImageData(ImageUrls.imageDownloadFailUrl, {(result) in
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
