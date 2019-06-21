//
//  PhotoViewController.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

protocol PhotoViewControllerInterface {
    var presenter: PhotoPresenterInterface? {get set}
}

class PhotoViewController: UIViewController, ReusableInterface, PhotoViewControllerInterface {

    @IBOutlet private weak var imageView: UIImageView!
    
    var presenter: PhotoPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = presenter?.photo {
            updatePhoto(photo: photo)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = presenter?.photo.title ?? "Photo"
    }
    
    // MARK: Private
    private func updatePhoto(photo: Photo) {
        let url = URL(string: photo.url)
        let placeholder = UIImage(named: Constants.placeholderImageName)
        
        imageView.sd_setImage(with: url, placeholderImage: placeholder)
    }
}
