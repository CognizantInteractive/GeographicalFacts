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
    lazy var contentViewWidth: NSLayoutConstraint = {
        let viewWidth = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        viewWidth.isActive = true
        return viewWidth
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubViews()
        setUpConstraintsForControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority
        horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        contentViewWidth.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 30))
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        clearsContextBeforeDrawing = true
        contentView.clearsContextBeforeDrawing = true
        titleLabel.text = nil
        descriptionLabel.text = nil
        factImageView.image = nil
    }
}

extension CollectionViewCell {
    func addSubViews() {
            contentView.addSubview(titleLabel)
            contentView.addSubview(descriptionLabel)
            contentView.addSubview(factImageView)
        }
    
//    func loadTheData() {
//        factImageView.image = UIImage(named: "defaultimage")
//        titleLabel.text = "Fact Title"
//        descriptionLabel.text = "Beavers are second only to humans"
//    }
    
    func loadFactCellData(fact: Fact) {
        titleLabel.text = fact.title ?? CommonMessages.emptyString
        descriptionLabel.text = fact.description ?? CommonMessages.emptyString
        guard let imageURL = fact.imageHref  else { return }
        let fileManager = FactsFileManager()
        if let image = fileManager.loadFactImageFromCacheIfPresent(imageURL: imageURL) {
            factImageView.image = image
        } else {
            factImageView.image = UIImage(named: ImageNames.defaultImageName)
        }
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
    
    func setPreferred(width: CGFloat) {
        titleLabel.preferredMaxLayoutWidth = width
        descriptionLabel.preferredMaxLayoutWidth = width
    }
}
