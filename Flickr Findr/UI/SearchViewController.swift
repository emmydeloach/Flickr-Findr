//
//  SearchViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var photos: [Photo] = []
    var page = 1
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: String(describing: SearchViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecucle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchPhotoResults(with: "gorilla")
    }
    
    // MARK: - Setup
    
    private func setUpUI() {
        
    }
    
    private func setUpSearchBar() {
        
        // MAke sure to reset page count on new searches
    }
    
    private func setUpCollectionView() {
        
    }
    
    // MARK: - Search Bar Delegate
    
    // MARK: - Collection View Delegate
    
    // MARK: - Networking

    private func fetchPhotoResults(with keyword: String? = nil) {
        
        APIService.fetchPhotos(with: keyword, page: page) { photos, error in
            
            if let error = error {
                
                DDLogWarn("Encountered error during fetch request: \(error.localizedDescription)")
                // TODO: Show toast on failed request
                return
            }
            
            DDLogDebug("Successfully fetched \(photos.count) photo results")
            
            self.photos = photos
            self.page += 1
        }
    }
}
