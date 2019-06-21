//
//  AppInteractor.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

enum InteractorResultType {
    case success(data: Data)
    case failure(error:Error?)
}

protocol AppInteractorInterface {
    var delegate : AppInteractorDelegate? { get set }
    func fetchPhotos()
}

protocol AppInteractorDelegate: class {
    func fetchPhotosRequestCompleted(result: InteractorResultType)
}

class AppInteractor: AppInteractorInterface {
    weak var delegate: AppInteractorDelegate?
    private var networkTask: NetworkTaskInterfaceProtocol
    
    init(networkTask: NetworkTaskInterfaceProtocol) {
        self.networkTask = networkTask
    }
    
    func fetchPhotos() {
        networkTask.fetchImages(url: Constants.albumUrl, onSuccess: {[weak self] (data) in
            self?.delegate?.fetchPhotosRequestCompleted(result: .success(data: data))
        }) {[weak self] (error) in
            self?.delegate?.fetchPhotosRequestCompleted(result: .failure(error: error))
        }
    }
}
