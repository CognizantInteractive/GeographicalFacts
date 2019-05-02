//
//  CellViewModel.swift
//  GeographicalFacts
//
//  Created by 273490 on 02/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation

//View model for collectionview cell
class CellViewModel {
    var factData: Fact
    var imageDownloadState: ImageDownloadState = .downloadNotStarted
    
    init(factData: Fact) {
        self.factData = factData
    }
}
