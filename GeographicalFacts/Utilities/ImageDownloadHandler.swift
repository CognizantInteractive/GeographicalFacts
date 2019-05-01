//
//  ImageDownloadHandler.swift
//  GeographicalFacts
//
//  Created by 273490 on 01/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation

import UIKit

protocol ImageDownloadHandler: class {
    //Protocol function to inform that image download is completed.
    func updatedImageAtIndex(index: Int, cell: UICollectionViewCell, result: ImageDownloadResult)
}
