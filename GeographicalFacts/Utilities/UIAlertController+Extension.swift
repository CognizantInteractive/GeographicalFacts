//
//  UIAlertController+Extension.swift
//  GeographicalFacts
//
//  Created by 273490 on 02/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit

//UIAlertController extension to create an alertcontroller
extension UIAlertController {
    
    static func showAlertView(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ErrorMessages.okButtonTitle,
                                   style: UIAlertAction.Style.default,
                                   handler: nil)
        alertController.addAction(action)
        return alertController
    }
    
}
