//
//  ViewController.swift
//  GeographicalFacts
//
//  Created by 273490 on 30/04/19.
//  Copyright © 2019 cognizant. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var progressIndicatorView = ProgressIndicatorView()
    private var refreshControl: UIRefreshControl!
    private var viewModel = ViewModel()
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: viewModel.getPreferredWith(forSize: self.view.bounds.size),
                                              height: CGFloat(Float(CellSize.estimatedHeight)))
        return flowLayout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = CollectionView(frame: .zero,
                                            collectionViewLayout: flowLayout)
        return collectionView
    }()
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.getLoadingTitle()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        configureViews()
        addNotificationObservers()
        getFactsData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = viewModel.getCollectionViewFrame(width: self.view.frame.size.width)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MainViewController {
    // MARK: - Functions
    func configureViews() {
        self.collectionView.dataSource = viewModel
        self.view.addSubview(self.collectionView)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.blue
        refreshControl.attributedTitle = NSAttributedString(string: CommonMessages.pullToRefresh)
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        progressIndicatorView.addActivityIndicatorToTheView(view: self.view)
    }
    //function which gets called on refreshcontrol pull
    @objc func refresh(sender: AnyObject) {
        getFactsData()
    }
    //function to stop the refresh control
    func stopRefreshControl() {
        refreshControl.endRefreshing()
    }
    //function which invokes the fetchFacts() to fetch the Fact JSON from server
    func getFactsData() {
        progressIndicatorView.displayActivityIndicatorView(show: true)
        viewModel.fetchFacts(ServiceUrls.factsFetchUrl, { [weak self] (result) in
            DispatchQueue.main.async {
                self?.updateUIAfterRefresh(result: result)
            }
        })
    }
    //function which performs the UI updation after Fact JSON fetch
    func updateUIAfterRefresh(result: FactsFetchResult) {
        progressIndicatorView.displayActivityIndicatorView(show: false)
        stopRefreshControl()
        switch result {
        case .success:
            self.title = viewModel.getFactsTitle()
            collectionView.isHidden = false
            collectionView.reloadData()
        case .failure(let errorMsg):
            self.title = viewModel.getEmptyTitle()
            showErrorAlert(message: errorMsg)
        }
    }
    //function to display any type of error message
    func showErrorAlert(message: String) {
        let alertController = UIAlertController.showAlertView(title: ErrorMessages.errorAlertTitle, message: message)
        self.present(alertController, animated: true, completion: nil)
    }
    func invalidateLayoutAndReloadTheCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
    func addNotificationObservers() {
        self.regiesterForNotificationName(NotificationNames.finishedImageDownload)
    }
    func regiesterForNotificationName(_ notificationName: Notification.Name) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRecieveNotification(_:)),
                                               name: notificationName, object: nil )
    }
    @objc func didRecieveNotification(_ notification: Notification) {
        if notification.name == NotificationNames.finishedImageDownload {
            let userInfo    = notification.userInfo
            let urlStr   = userInfo?[UserInfoKeys.urlKey] as? String
            let result   = userInfo?[UserInfoKeys.resultKey] as? ImageDownloadResult
            
            if let unWrappedUrlString = urlStr, let  unWrappedResult =  result {
                switch unWrappedResult {
                case .success:
                    self.didFinishImageDownload(urlString: unWrappedUrlString)
                case .failure(let errorString):
                    print(errorString)
                    self.didFailImageDownload(urlString: unWrappedUrlString)
                }
            }
        }
    }
    func didFailImageDownload(urlString: String) {
        for cell in self.collectionView.visibleCells {
            if  let customCell = cell as? CollectionViewCell,
                let imageUrlString = customCell.cellViewModel?.factData.imageHref,
                imageUrlString ==  urlString {
                customCell.showActivityIndicatorView(false)
                break
            }
        }
    }
    func didFinishImageDownload(urlString: String) {
        for cell in self.collectionView.visibleCells {
            if  let customCell = cell as? CollectionViewCell,
                let imageUrlString = customCell.cellViewModel?.factData.imageHref,
                urlString ==  imageUrlString {
                if let indexPath = collectionView.indexPath(for: customCell) {
                    collectionView.reloadItems(at: [indexPath])
                }
                break
            }
        }
    }
}
// MARK: - Orientation Functions
extension MainViewController {
    //invalidate the collection view layout and recalculate the visible cell sizes when the transition happens
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
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    //calcualting the estimated item size and to recalculate the visible cell sizes
    func estimateVisibleCellSizes(to size: CGSize) {
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: viewModel.getPreferredWith(forSize: size),
                                                  height: CellSize.estimatedHeight)
        }
        collectionView.visibleCells.forEach({ cell in
            if let cell = cell as? CollectionViewCell {
                cell.setPreferred(width: viewModel.getPreferredWith(forSize: size))
            }
        })
    }
}
