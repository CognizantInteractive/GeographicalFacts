//
//  FactsFileManager.swift
//  GeographicalFacts
//
//  Created by 273490 on 01/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit

//Class which downloads the image and save in Cache
class FactsFileManager {
    
    static let fileManager: FactsFileManager = {
        let shared =   FactsFileManager()
        return shared
    }()
    
    private init () {
        
    }
    let fileManger = FileManager.default
    // MARK: - Functions
    //This function returns the folder path in which images are saved
    func getTheFactsImageFolderPath() -> String {
        let dirPaths = fileManger.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheURL = dirPaths[0]
        let imageFolderPath = cacheURL.appendingPathComponent(FactImages.factImagesFolder).path + "/"
        return imageFolderPath
    }
    
    //This function saves the image in App's Cache/FactsImages folder
    func saveImageToCacheDirectory(newImageData: UIImage, imageURL: String) -> Bool {
        var success = false
        guard let imageURL = URL(string: imageURL) else {
            return false
        }
        let imageName = imageURL.lastPathComponent
        let factsImagesFolderPath = getTheFactsImageFolderPath()
        do {
            if !fileManger.fileExists(atPath: factsImagesFolderPath) {
                try fileManger.createDirectory(atPath: factsImagesFolderPath,
                                               withIntermediateDirectories: true, attributes: nil)
            }
            let imagePATH = getTheFactsImageFolderPath().appending(imageName)
            if !fileManger.fileExists(atPath: imagePATH) {
                guard let imageData = newImageData.jpegData(compressionQuality: 0.75) else {
                    return false
                }
                success = fileManger.createFile(atPath: imagePATH as String, contents: imageData, attributes: nil)
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        return success
    }
    
    //This function returns the particular fact image if present in Cache folder,
    //If not present, start the image download
    func loadFactImageFromCache(imageUrlString: String) -> UIImage? {
        var loadedImage: UIImage?
        guard let imageURL = URL(string: imageUrlString) else {
            return nil
        }
        let imageName = imageURL.lastPathComponent
        let imagePath = getTheFactsImageFolderPath().appending(imageName)
        if fileManger.fileExists(atPath: imagePath) {
            loadedImage = UIImage(contentsOfFile: imagePath)
            return loadedImage
        }
        
        self.downloadImageForUrl(url: imageUrlString)
        return nil
    }
    
    //This function initiates the image download and send the notfication on completion.
    func downloadImageForUrl(url: String) {
        self.getImageData(url, { (result) in
            var userInfo: [String: Any] = [String: Any]()
            userInfo[UserInfoKeys.urlKey] = url
            userInfo[UserInfoKeys.resultKey] =  result
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NotificationNames.finishedImageDownload,
                                                object: nil,
                                                userInfo: userInfo)
            }
        })
    }
    
    //This function downloads each fact image to be displayed.
    //Image gets saved in App's Cache folder once download is successfully completed,
    //so that next time this image can be used for display without downloading it again.
    func getImageData(_ imageURL: String,
                      _ completion: @escaping (ImageDownloadResult) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            return completion(.failure(ErrorMessages.networkErrorMessgae))
        }
        NetworkManager.getImageData(imageURL, { [weak self] (result) in
            switch result {
            case .success(let imageData):
                guard let newImageData = imageData as? UIImage else {
                    return completion(.failure(ErrorMessages.commonErrorMessage))
                }
                //saving the image to cache
                _ =  self?.saveImageToCacheDirectory(newImageData: newImageData, imageURL: imageURL)
                completion(.success)
            case .failure(let errorMsg):
                completion(.failure(errorMsg))
            }
        })
    }
    
    //This function deletes the saved images from cache
    func deleteImagesFolder() {
        let factsImagesFolderPath = getTheFactsImageFolderPath()
        do {
            if fileManger.fileExists(atPath: factsImagesFolderPath) {
                try fileManger.removeItem(atPath: factsImagesFolderPath)
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}
