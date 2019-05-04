//
//  CollectionView.swift
//  GeographicalFacts
//
//  Created by 273490 on 04/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit

class CollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(CollectionViewCell.self,
                      forCellWithReuseIdentifier: CellIdentifiers.CollectionViewCellId)
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.gray
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
}
