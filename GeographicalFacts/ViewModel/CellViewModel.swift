//
//  CellViewModel.swift
//  GeographicalFacts
//
//  Created by 273490 on 02/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit
//View model for collectionview cell
class CellViewModel {
    var factData: Fact
    
    init(factData: Fact) {
        self.factData = factData
    }
    // MARK: - Functions
    func getFactTitle() -> String {
        return factData.title ??  CommonMessages.emptyString
    }
    func getFactDescription() -> String {
        return factData.description ??  CommonMessages.emptyString
    }
}
