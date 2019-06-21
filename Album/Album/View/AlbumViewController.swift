//
//  AlbumViewController.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit
import SDWebImage

protocol AlbumViewControllerInterface {
    var presenter: AlbumPresenterInterface? {get set}
}

class AlbumViewController: UICollectionViewController, ReusableInterface, AlbumViewControllerInterface {
    var presenter: AlbumPresenterInterface?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AlbumViewController.handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var reachabiltyTask = ReachabilityTask()

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.addSubview(refreshControl)
        
        fetchPhotos(showLoader: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Album"
    }
    
    // MARK: Private
    func fetchPhotos(showLoader: Bool) {
        guard reachabiltyTask.isReachable else {
            refreshControl.endRefreshing()
            
            if presenter?.arrPhoto == nil || presenter!.arrPhoto!.count == 0 {
                showErrorView(Constants.noInternetMessage)
            }
            return
        }
        if showLoader {
            loadingView.startAnimating()
        }
        presenter?.fetchPhotos()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchPhotos(showLoader: false)
    }
    
    private func showErrorView(_ message: String) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.showErrorView(message)
            }
            return
        }
        hideLoading()
        
        let errorView = view.viewWithTag(Constants.errorViewTag)
        if let errorView  = errorView as? ErrorViewInterface {
            errorView.updateError(message: message)
            return
        }
        
        let errView = AppUtil.getErrorView()
        errView.updateError(message: message)
        errView.delegate = self
        if let errView = errView as? UIView {
            errView.frame = view.bounds
            errView.tag = Constants.errorViewTag
            view.addSubview(errView)
        }
    }
    
    private func hideLoading() {
        loadingView.stopAnimating()
        refreshControl.endRefreshing()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.arrPhoto?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoThumbnailCollectionViewCell.reuseIdentifier, for: indexPath)
    
        guard let photoCell = cell as? PhotoThumbnailCollectionViewCell, let photo = presenter?.arrPhoto?[indexPath.row] else {
            return cell
        }
        photoCell.updatePhoto(url: photo.thumbnailUrl)
    
        return photoCell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navVC = self.navigationController {
            presenter?.showDetail(index: indexPath.row, parent: navVC)
        }
    }
}

// MARK: AlbumPresenterDelegate
extension AlbumViewController: AlbumPresenterDelegate {
    func fetchPhotosRequestCompleted(result: AlbumPresenterResultType) {
        switch result {
        case .success():
            DispatchQueue.main.async {
                self.hideLoading()
                self.collectionView?.reloadData()
            }
        case .failure(error: let error):
            showErrorView(error?.localizedDescription ?? Constants.genericErrorMessage)
        }
    }
}

// MARK: ErrorViewDelegate
extension AlbumViewController: ErrorViewDelegate {
    func errorViewDidClickRetry() {
        if let errView = view.viewWithTag(Constants.errorViewTag) {
            errView.removeFromSuperview()
        }
        fetchPhotos(showLoader: true)
    }
}
