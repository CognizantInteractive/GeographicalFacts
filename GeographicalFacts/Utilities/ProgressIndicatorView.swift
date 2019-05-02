//
//  ProgressIndicatorView.swift
//  GeographicalFacts
//
//  Created by 273490 on 02/05/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit

//Custom class for adding activityindicator
class ProgressIndicatorView {
    private var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    //adding the activityindicator to the specified view and setting the constraints
    func addActivityIndicatorToTheView(view: UIView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .red
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //dispalying/hiding the activityindicator
    func displayActivityIndicatorView(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = !show
    }
}
