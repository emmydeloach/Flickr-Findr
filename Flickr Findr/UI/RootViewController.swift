//
//  RootViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

class RootViewController: UIViewController {
    
    // MARK: - Properties
    
    var photos: [Photo] = []
    var page = 1
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: String(describing: RootViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecucle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchPopularPhotos()
    }
    
    // MARK: - Networking

    private func fetchPopularPhotos() {
        
        DDLogDebug("Attempting to fetch popular photos...")

        APIService.getPopular(page) { photos, error in
            
            if let error = error {
                
                DDLogWarn("Encountered error during fetch request: \(error.localizedDescription)")
                return
            }
            
            DDLogDebug("Successfully fetched \(photos.count) popular results")
            
            self.photos = photos
            self.page += 1
        }
    }
    
    private func searchPhotos(with keyword: String = "gorilla") {
        
        DDLogDebug("Attempting to search photos with keyword: \(keyword)")
        
        APIService.searchPhotos(with: keyword, page: page) { photos, error in
            
            if let error = error {
                
                DDLogWarn("Encountered error during search request: \(error.localizedDescription)")
                return
            }
            
            DDLogDebug("Successfully fetched \(photos.count) search results")
            
            self.photos = photos
            self.page += 1
        }
    }
}
