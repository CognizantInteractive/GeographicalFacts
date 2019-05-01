//
//  NetworkManager.swift
//  GeographicalFacts
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import Alamofire
// Alamofire wrapper class to download Facts JSON and image
class NetworkManager: NSObject {
    
    //Function to get the json data from server
    public static func getFactJSONData(_ endPointURL: String,
                                       _ apiRequestCompletionHandler:@escaping (FactsFetchStatus) -> Void) {
        guard let endPointURL = URL(string: endPointURL) else {
            apiRequestCompletionHandler(.failure(ErrorMessages.invalidUrlErrorMessage))
            return
        }
        let request = Alamofire.request(endPointURL,
                                        method: Alamofire.HTTPMethod.get,
                                        parameters: nil,
                                        encoding: JSONEncoding.default,
                                        headers: nil)
        //request call and handling the response from the service call
        request.responseData(completionHandler: {(response) in
            switch response.result {
            case .success:
                if let responseData = response.result.value {
                    let dataString = String(data: responseData, encoding: String.Encoding.isoLatin1)
                    guard let modifiedData = dataString?.data(using: String.Encoding.utf8) else {
                        return apiRequestCompletionHandler(.failure(ErrorMessages.jsonConversionErrorMessage))
                    }
                    do {
                        let jsonDecoder = JSONDecoder()
                        var decodedData = FactData()
                        decodedData = try jsonDecoder.decode(FactData.self, from: modifiedData)
                        apiRequestCompletionHandler(.success(decodedData as AnyObject?))
                    } catch let error as NSError {
                        apiRequestCompletionHandler(.failure(error.localizedDescription))
                    }
                }
            case .failure(let error as NSError):
                apiRequestCompletionHandler(.failure(error.localizedDescription))
            }
        })
    }
    
    //Function to get the image data from server
    public static func getImageData(_ imageURL: String,
                                    _ apiRequestCompletionHandler:@escaping (ImageDownloadStatus) -> Void) {
        guard let imageURL = URL(string: imageURL) else {
            print(ErrorMessages.invalidUrlErrorMessage); return }
        //request call and handling the response from the service call
        Alamofire.request(imageURL).responseData { (response) in
            switch response.result {
            case .success:
                if let imageData = response.data {
                    guard let newImage = UIImage(data: imageData) else {
                        apiRequestCompletionHandler(.failure(ErrorMessages.imageConversionErrorMessage))
                        return
                    }
                    apiRequestCompletionHandler(.success(newImage as AnyObject?))
                }
            case .failure(let error as NSError):
                apiRequestCompletionHandler(.failure(error.localizedDescription))
            }
        }
    }
}
