//
//  EnlargedPhotoViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/7/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import SDWebImage // TODO: maybe switch to AlamofireImage so 

class EnlargedPhotoViewController: UIViewController {
    
    // MARK: - Outlets
    
    // TODO: Add dismiss button
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    private let image: UIImage?
    private let subtitle: String
    
    // MARK: - Init
    
    init(image: UIImage?, subtitle: String) {
        
        self.image = image
        self.subtitle = subtitle
        
        super.init(nibName: String(describing: EnlargedPhotoViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setUpUI()
    }
    
    private func setUpUI() {
        
        imageView.image = image
        titleLabel.text = subtitle
        
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
}
