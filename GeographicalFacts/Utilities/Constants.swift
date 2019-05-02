//
//  Constants.swift
//  GeographicalFacts
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation

struct ServiceUrls {
    static let factsFetchUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}
struct TestDataFetchUrl {
    static let badJSONUrl = "https://dl.dropboxusercontent.com/2iodh4vg0eortkl/facts.json"
    static let factsFetchInvalidUrl = ""
}
struct ImageUrls {
    static let imageDownloadFailUrl = "http://files.turbosquid.com/Preview/trebucheta.84b2-6ce718a327a9Larger.jpg"
    static let imageDownloadSuccessUrl = "http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png"
}
struct CellIdentifiers {
    static let CollectionViewCellId = "CollectionViewCell"
}
struct ErrorMessages {
    static let networkErrorMessgae           = "Network is not present, please try again later."
    static let commonErrorMessage            = "Some error occured, please try again later."
    static let invalidUrlErrorMessage        = "Invalid URL"
    static let jsonConversionErrorMessage    = "Could not convert data to UTF-8 format"
    static let imageConversionErrorMessage   = "Could not convert data to image"
    static let errorAlertTitle               = "Error"
    static let okButtonTitle                 = "Ok"
}
struct CommonMessages {
    static let emptyString          = ""
    static let loadingTitle         = "Loading, Please wait.."
    static let pullToRefresh        = "Pull to refresh.."
}
struct DeviceModel {
    static let iPadModel = "iPad"
}
struct FactImages {
    static let factImagesFolder = "FactsImages"
}
struct ImageNames {
    static let defaultImageName = "defaultimage"
}
enum FactsFetchStatus {
    case success(AnyObject?), failure(String)
}
enum FactsFetchResult {
    case success, failure(String)
}
enum ImageDownloadStatus {
    case success(AnyObject?), failure(String)
}
enum ImageDownloadResult {
    case success, failure(String)
}
