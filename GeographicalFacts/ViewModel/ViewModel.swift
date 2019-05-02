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
    weak var delegate: ImageDownloadHandler?
    
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
    
    //  This function downloads each fact image to be displayed.
    //  Image gets saved in App's Cache folder once download is successfully completed,
    //  so that next time this image can be used for display without downloading it again.
    func getImageData(_ imageURL: String,
                      _ completion: @escaping (ImageDownloadResult) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            return completion(.failure(ErrorMessages.networkErrorMessgae))
        }
        NetworkManager.getImageData(imageURL, { (result) in
            switch result {
            case .success(let imageData):
                guard let newImageData = imageData as? UIImage else {
                    return completion(.failure(ErrorMessages.commonErrorMessage))
                }
                //saving the image to cache
                let factsFileManager = FactsFileManager()
                _ =  factsFileManager.saveImageToCacheDirectory(newImageData: newImageData, imageURL: imageURL)
                completion(.success)
            case .failure(let errorMsg):
                completion(.failure(errorMsg))
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
    
    //This function checks whether the particular fact image is already downloaded and saved in cache or not.
    //If image is not present, it intiates the image download process for the particular fact.
    func checkTheImageDownloadStatus(factModelData: Fact, index: Int, cell: UICollectionViewCell) {
        guard let imageURL = factModelData.imageHref else {
            return
        }
        let fileManager = FactsFileManager()
        if  !fileManager.isImagePresentInCacheFolder(imageURL: imageURL) {
            startImageDownLoadForIndex(factModelData: factModelData, index: index, cell: cell)
        }
    }
    
    //  This function initiates the image download, on completion it calls the
    //  delegate method to reload the cell if it is a visible cell
    func startImageDownLoadForIndex(factModelData: Fact, index: Int, cell: UICollectionViewCell) {
        guard let imageURL = factModelData.imageHref else {
            return
        }
        self.getImageData(imageURL, { [weak self] (result) in
            DispatchQueue.main.async {
                self?.delegate?.updatedImageAtIndex(index: index, cell: cell, result: result)
            }
        })
    }
    
    //function to return the number of columns
    func getNoOfColumns() -> CGFloat {
        var noOfColumns: CGFloat = 1.0
        let deviceModel = UIDevice.current.model
        if deviceModel == DeviceModel.iPadModel {
            noOfColumns = 2.0
        }
        return noOfColumns
    }
}

// MARK: - UICollectionViewDataSource
extension ViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return factData.rows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let factCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.CollectionViewCellId,
                                                             for: indexPath) as? CollectionViewCell {
            if let factData =  self.factData.rows {
                let factModelData = factData[indexPath.row]
                checkTheImageDownloadStatus(factModelData: factModelData, index: indexPath.row, cell: factCell)
                factCell.loadFactCellData(fact: factModelData)
            }
            factCell.layoutIfNeeded()
            return factCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
