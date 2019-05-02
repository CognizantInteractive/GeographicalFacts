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
    var imageDownloadState: ImageDownloadState = .downloadNotStarted
    
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
    func getFactImage() -> UIImage? {
        guard let imageURL = factData.imageHref  else {
            return nil
        }
        let fileManager = FactsFileManager()
        if let image = fileManager.loadFactImageFromCacheIfPresent(imageURL: imageURL) {
           return image
        } else {
            return UIImage(named: ImageNames.defaultImageName)
        }
    }
}
