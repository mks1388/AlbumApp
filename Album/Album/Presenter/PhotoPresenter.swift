//
//  PhotoPresenter.swift
//  Album
//
//  Created by Mithilesh Singh on 21/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

protocol PhotoPresenterInterface {
    var photo: Photo {get set}
}

class PhotoPresenter: PhotoPresenterInterface {
    var photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
}
