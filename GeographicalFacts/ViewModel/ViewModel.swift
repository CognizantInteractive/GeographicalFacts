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
    
    //invokes the network call for json download.
    func fetchFacts(_ endPointURL: String,
                    _ completion: @escaping (FactsFetchResult) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            return completion(.failure(ErrorMessages.networkErrorMessgae))
        }
        NetworkManager.getFactJSONData(endPointURL, {(result) in
            switch result {
            case .success(let factData):
                guard let parsedData = factData as? FactData else {
                    return completion(.failure(ErrorMessages.commonErrorMessage))
                }
                self.checkForValidFactData(data: parsedData)
                if self.factData.rows != nil {
                    return completion(.success)
                } else {
                    return completion(.failure(ErrorMessages.commonErrorMessage))
                }
            case .failure(let errorMsg):
                return completion(.failure(errorMsg))
            }
        })
    }
    
    //This function removes the particular fact data if all the fact params are invalid
    func checkForValidFactData(data: FactData) {
        factData.title = data.title ??  CommonMessages.emptyString
        if let rowArray = data.rows {
            let filterData = rowArray.filter {($0.title != nil) ||
                ($0.description != nil) ||
                ($0.imageHref != nil)}
            factData.rows = filterData
        } else {
            factData.rows = nil
        }
    }
    func getFactsTitle() -> String {
        return factData.title ??  CommonMessages.emptyString
    }
    
    func getEmptyTitle() -> String {
        return CommonMessages.emptyString
    }
}

// MARK: - UICollectionViewDataSource
extension ViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factData.rows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let factCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                             for: indexPath) as? CollectionViewCell {
            if let factData =  self.factData.rows {
                let factModelData = factData[indexPath.row]
                factCell.loadFactCellData(fact: factModelData)
            }
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
