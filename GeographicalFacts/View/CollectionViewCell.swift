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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.titleFont
        return label
    }()
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        return label
    }()
    lazy var factImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy private var progressIndicatorView: ProgressIndicatorView = {
        let activityIndicatorView = ProgressIndicatorView()
        return activityIndicatorView
    }()
    lazy var contentViewWidth: NSLayoutConstraint = {
        let viewWidth = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        viewWidth.isActive = true
        return viewWidth
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
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
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: CellSize.estimatedHeight))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearsContextBeforeDrawing = true
        contentView.clearsContextBeforeDrawing = true
        titleLabel.text = nil
        descriptionLabel.text = nil
        factImageView.image = nil
        showActivityIndicatorView(false)
    }
    
    var cellViewModel: CellViewModel? {
        didSet {
            titleLabel.text = cellViewModel?.getFactTitle()
            descriptionLabel.text = cellViewModel?.getFactDescription()
            guard let imageURLString = cellViewModel?.factData.imageHref  else {
                return
            }
            if let image = FactsFileManager.fileManager.loadFactImageFromCache(imageUrlString: imageURLString) {
                showActivityIndicatorView(false)
                factImageView.image = image
            } else {
                factImageView.image =  UIImage(named: ImageNames.defaultImageName)
                showActivityIndicatorView(true)
            }
        }
    }
}

extension CollectionViewCell {
    // MARK: - Functions
    func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(factImageView)
        progressIndicatorView.addActivityIndicatorToTheView(view: factImageView)
    }
    
    //Function to set the layout constraints for the subviews
    func setUpConstraintsForControls() {
        let marginGuide = contentView.layoutMarginsGuide
        
        factImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 5).isActive = true
        factImageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 5).isActive = true
        factImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: factImageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func setPreferred(width: CGFloat) {
        titleLabel.preferredMaxLayoutWidth = width
        descriptionLabel.preferredMaxLayoutWidth = width
    }
    
    //show/hide the activityindicator
    func showActivityIndicatorView(_ show: Bool) {
        progressIndicatorView.displayActivityIndicatorView(show: show)
    }
}
