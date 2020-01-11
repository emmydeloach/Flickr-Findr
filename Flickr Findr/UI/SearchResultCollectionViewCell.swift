//
//  SearchResultCollectionViewCell.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/5/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import Reusable
import SDWebImage

class SearchResultCollectionViewCell: UICollectionViewCell, NibReusable {

    static let defaultHeight: CGFloat = 180
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Setup
    
    func load(_ result: SearchResult) {
        
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: result.imageURL) { _, _, _, _ in
            
            self.titleLabel.text = result.title
        }
    }
}
