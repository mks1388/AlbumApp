//
//  AlbumPresenter.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

enum AlbumPresenterResultType {
    case success()
    case failure(error:Error?)
}

protocol AlbumPresenterInterface {
    var delegate : AlbumPresenterDelegate? {get set}
    var arrPhoto: [Photo]? {get set}
    
    func fetchPhotos()
    func showDetail(index: Int, parent: UINavigationController)
}

protocol AlbumPresenterDelegate: class {
    func fetchPhotosRequestCompleted(result: AlbumPresenterResultType)
}

class AlbumPresenter: AlbumPresenterInterface {
    weak var delegate: AlbumPresenterDelegate?
    var arrPhoto: [Photo]?
    
    private var interactor: AppInteractorInterface
    private var router: AppRouterInterface
    
    init(interactor: AppInteractorInterface, router: AppRouterInterface) {
        self.interactor = interactor
        self.router = router
        self.interactor.delegate = self
    }
    
    func fetchPhotos() {
        interactor.fetchPhotos()
    }
    
    func showDetail(index: Int, parent: UINavigationController) {
        guard let arrPhoto = arrPhoto, arrPhoto.count > index, let vc = AppUtil.getViewController(identifier: PhotoViewController.reuseIdentifier) as? PhotoViewController else {
            return
        }
        let photo = arrPhoto[index]
        vc.presenter = PhotoPresenter(photo: photo)
        
        router.showDetail(parent: parent, child: vc)
    }
}

extension AlbumPresenter: AppInteractorDelegate {
    func fetchPhotosRequestCompleted(result: InteractorResultType) {
        switch result {
        case .success(data: let data):
            do {
                let decoder = JSONDecoder()
                let modelArr = try decoder.decode([Photo].self, from: data)
                arrPhoto = modelArr
                delegate?.fetchPhotosRequestCompleted(result: .success())
            } catch let error {
                delegate?.fetchPhotosRequestCompleted(result: .failure(error: error))
            }
            
        case .failure(error: let error):
            delegate?.fetchPhotosRequestCompleted(result: .failure(error: error))
        }
    }
}
