//
//  CollectionViewCell.swift
//  GeographicalFacts
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import Foundation
import UIKit
class CollectionViewCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        return label
    }()
    lazy var factImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentView.leftAnchor.constraint(equalTo: leftAnchor),
                                     contentView.rightAnchor.constraint(equalTo: rightAnchor),
                                     contentView.topAnchor.constraint(equalTo: topAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        addSubViews()
        setUpConstraintsForControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionViewCell {
    func addSubViews() {
            contentView.addSubview(titleLabel)
            contentView.addSubview(descriptionLabel)
            contentView.addSubview(factImageView)
        }
    
    func loadTheData() {
        factImageView.image = UIImage(named: "defaultimage")
        titleLabel.text = "Fact Title"
        descriptionLabel.text = "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony"
    }
    //Function to set the layout constraints for the subviews
    func setUpConstraintsForControls() {
        let marginGuide = contentView.layoutMarginsGuide
        factImageView.translatesAutoresizingMaskIntoConstraints = false
        factImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 5).isActive = true
        factImageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 5).isActive = true
        factImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: factImageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
}

