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
        flowLayout.estimatedItemSize = CGSize(width: self.preferredWith(forSize: self.view.bounds.size),
                                              height: CGFloat(Float(30)))
        return flowLayout
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Geographical Facts"
        viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureViews()
        getFactsData()
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
                                     forCellWithReuseIdentifier: CellIdentifiers.CollectionViewCellId)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.gray
        collectionView.isHidden = true
        self.collectionView.dataSource = viewModel
        self.view.addSubview(self.collectionView)
    }
    
    //function which invokes the fetchFacts() to fetch the Fact JSON from server
    func getFactsData() {
        viewModel.fetchFacts(ServiceUrls.factsFetchUrl, { [weak self] (result) in
            DispatchQueue.main.async {
                self?.updateUIAfterRefresh(result: result)
            }
        })
    }
    
    //function which performs the UI updation after Fact JSON fetch
    func updateUIAfterRefresh(result: FactsFetchResult) {
        switch result {
        case .success:
            self.title = viewModel.getFactsTitle()
            collectionView.isHidden = false
            collectionView.reloadData()
        case .failure(let errorMsg):
            self.title = viewModel.getEmptyTitle()
            print(errorMsg)
        }
    }
    
    func invalidateLayoutAndReloadTheCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
        }
    }
}

//Orientation Support
//invalidate the collection view layout and recalculate the visible cell sizes when the transition happens
extension MainViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
                self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
            else {
                return
        }
        invalidateLayoutAndReloadTheCollectionView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.estimateVisibleCellSizes(to: size)
        coordinator.animate(alongsideTransition: { _ in
        }, completion: { _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }
    
    //to calculate the preferred width for the estimated size
    func preferredWith(forSize size: CGSize) -> CGFloat {
        let noOfColumns: CGFloat = 1.0
        return (size.width - 30) / noOfColumns
    }
    
    //calcualting the estimated item size and to recalculate the visible cell sizes
    func estimateVisibleCellSizes(to size: CGSize) {
        guard let collectionView = self.collectionView else {
            return
        }
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: self.preferredWith(forSize: size), height: 30)
        }
        collectionView.visibleCells.forEach({ cell in
            if let cell = cell as? CollectionViewCell {
                cell.setPreferred(width: self.preferredWith(forSize: size))
            }
        })
    }
}

// MARK: - ImageDownloadHandler delegate
extension MainViewController: ImageDownloadHandler {
    
    func updatedImageAtIndex(index: Int, cell: UICollectionViewCell, result: ImageDownloadResult) {
        switch result {
        case .success:
            let visibleItems = self.collectionView.indexPathsForVisibleItems
            for indexPath in visibleItems where indexPath.row == index {
                collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        case .failure(let errorMessage):
            print(errorMessage)
        }
    }
}
