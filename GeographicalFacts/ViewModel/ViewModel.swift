//
//  ViewModel.swift
//  GeographicalFacts
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit
class ViewModel: NSObject {
    var factData = FactData()
}

// MARK: - UICollectionViewDataSource
extension ViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let factCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                             for: indexPath) as? CollectionViewCell {
            factCell.loadTheData()
            factCell.layoutIfNeeded()
            return factCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
