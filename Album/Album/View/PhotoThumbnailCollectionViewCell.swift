//
//  PhotoThumbnailCollectionViewCell.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

protocol PhotoViewInterface {
    func updatePhoto(url: String, placeholder: String)
}
extension PhotoViewInterface {
    func updatePhoto(url: String, placeholder: String = Constants.placeholderImageName) {
        updatePhoto(url: url, placeholder: placeholder)
    }
}

class PhotoThumbnailCollectionViewCell: UICollectionViewCell, ReusableInterface, PhotoViewInterface {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func updatePhoto(url: String, placeholder: String) {
        let url = URL(string: url)
        let placeholder = UIImage(named: placeholder)
        
        imageView.sd_setImage(with: url, placeholderImage: placeholder)
    }
}
