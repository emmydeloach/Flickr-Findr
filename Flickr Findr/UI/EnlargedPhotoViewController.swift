//
//  EnlargedPhotoViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/7/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import SDWebImage 

class EnlargedPhotoViewController: UIViewController, BackgroundBlurable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dismissButton: RoundedButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: RoundedLabel!
    
    // MARK: - Properties
    
    private let result: SearchResult
    private let radius: CGFloat = 10
    
    // MARK: - Init
    
    init(result: SearchResult) {
        
        self.result = result
        
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
        
        applyBackgroundBlur()
        
        imageView.sd_setImage(with: result.imageURL, placeholderImage: UIImage(named: Constants.errorIcon))
        titleLabel.text = result.title
        
        dismissButton.roundCorners(radius: radius)
        titleLabel.roundCorners(radius: radius)
        
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButtonTapped() {
        
        dismiss(animated: true)
    }
}

