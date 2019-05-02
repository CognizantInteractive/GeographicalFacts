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
    
    //Function to inform that image download has started.
    func imageDownloadStartedAtIndex(index: Int,
                                     cell: UICollectionViewCell)
    
    //Function to inform that image download is completed.
    func imageDownloadCompletedAtIndex(index: Int,
                                       cell: UICollectionViewCell,
                                       result: ImageDownloadResult)
}
