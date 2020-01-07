//
//  PhotoCollectionViewCell.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/5/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import Reusable
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell, NibReusable {

    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Setup
    
    func load(result: Photo) {
        
        titleLabel.text = result.title
        imageView.sd_setImage(with: result.imageURL, placeholderImage: nil)
    }
}
