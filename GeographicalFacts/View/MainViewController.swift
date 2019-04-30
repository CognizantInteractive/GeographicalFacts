//
//  ViewController.swift
//  GeographicalFacts
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = ViewModel()
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        //estimated size
        flowLayout.estimatedItemSize = CGSize(width: width,
                                              height: CGFloat(Float(30)))
        return flowLayout
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Geographical Facts"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureViews()
        collectionView.reloadData()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = self.view.frame.size.width
        let frame =   CGRect(x: 0,
                             y: 0,
                             width: width,
                             height: UIScreen.main.bounds.size.height)
        self.collectionView.frame = frame
    }
}

extension MainViewController {
    
    func configureViews() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.collectionView.register(CollectionViewCell.self,
                                     forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.gray
        collectionView.isHidden = false
        self.collectionView.dataSource = viewModel
        self.view.addSubview(self.collectionView)
    }
    
}
