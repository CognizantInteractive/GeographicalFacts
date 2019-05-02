//
//  FactsAlertViewTests.swift
//  GeographicalFactsTests
//
//  Created by 273490 on 02/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import XCTest
@testable import GeographicalFacts

class FactsAlertViewTests: XCTestCase {

    override func setUp() {
    
    }

    override func tearDown() {
        
    }

    func testAlertViewIsCreatedOrNot() {
        let alertController = UIAlertController.showAlertView(title: ErrorMessages.errorAlertTitle,
                                                              message: ErrorMessages.commonErrorMessage)
        XCTAssertNotNil(alertController)
    }

}
