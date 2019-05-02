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
    var factsFileManager: FactsFileManager!
    
    override func setUp() {
        factsFileManager =  FactsFileManager()
    }

    override func tearDown() {
         factsFileManager = nil
    }
    
    //test for checking the Image folder path
    func testFactsImageFolderPath() {
        let fileManger = FileManager.default
        let dirPaths = fileManger.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheURL = dirPaths[0]
        let imageFolderPath = cacheURL.appendingPathComponent(FactImages.factImagesFolder).path + "/"
        XCTAssertEqual(factsFileManager.getTheFactsImageFolderPath(), imageFolderPath)
    }

}
