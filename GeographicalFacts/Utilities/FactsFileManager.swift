//
//  FactsFileManager.swift
//  GeographicalFacts
//
//  Created by 273490 on 01/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit

//Class which handles image data save in Cache folder
class FactsFileManager {
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
    
    //This function returns the particular fact image if present in Cache folder.
    func loadFactImageFromCacheIfPresent(imageURL: String) -> UIImage? {
        var loadedImage: UIImage?
        guard let imageURL = URL(string: imageURL) else {
            return nil
        }
        let imageName = imageURL.lastPathComponent
        let imagePath = getTheFactsImageFolderPath().appending(imageName)
        if fileManger.fileExists(atPath: imagePath) {
            loadedImage = UIImage(contentsOfFile: imagePath)
        }
        return loadedImage
    }
    
    //This function checks whether particular image is present in Cache or not.
    func isImagePresentInCacheFolder(imageURL: String) -> Bool {
        var isImageAlreadyPresent = false
        guard let imageURL = URL(string: imageURL) else {
            return false
        }
        let imageName = imageURL.lastPathComponent
        let imagePath = getTheFactsImageFolderPath().appending(imageName)
        if fileManger.fileExists(atPath: imagePath) {
            isImageAlreadyPresent = true
        }
        return isImageAlreadyPresent
    }
    
    //This function deletes the saved images in cache
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
