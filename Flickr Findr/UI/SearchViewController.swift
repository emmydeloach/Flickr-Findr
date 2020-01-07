//
//  SearchViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import SDWebImage
import MaterialComponents.MaterialSnackbar

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ResultsLayoutDelegate, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var photos: [Photo] = [] {
        didSet {
            resultsCollectionView.reloadData()
            resultsCollectionView.isHidden = photos.isEmpty
        }
    }
    
    private var keyword: String? {
        didSet {
            fetchPhotoResults()
        }
    }
    
    private var page = 1
    private var totalPages = 0
    
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
        
        setUpUI()
    }
    
    // MARK: - Setup
    
    private func setUpUI() {
        
        setUpSearchBar()
        setUpCollectionView()
        
        keyword = Constants.defaultSearchTerm
    }
    
    private func setUpSearchBar() {
        
        searchBar.delegate = self
    }
    
    private func setUpCollectionView() {
        
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        
        resultsCollectionView.register(cellType: PhotoCollectionViewCell.self)
        
        if let layout = resultsCollectionView.collectionViewLayout as? ResultsLayout {
         
            layout.delegate = self
        }
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Reset counts
        page = 1
        totalPages = 0
        photos = []
        keyword = searchBar.text
        view.endEditing(true)
        scrollToTop()
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCollectionViewCell.self)
        
        let nearEndOfResults = indexPath.item == photos.count - 1
        let moreResultsToFetch = totalPages > page
        if nearEndOfResults && moreResultsToFetch {
            
            DDLogInfo("Nearing end of results; fetching more")
            fetchPhotoResults()
        }
                
        cell.load(
            result: photos[indexPath.item]
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return PhotoCollectionViewCell.defaultHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presentEnlargedPhoto(
            photos[indexPath.item]
        )
    }
    
    // MARK: - Networking

    private func fetchPhotoResults() {
        
        guard let keyword = keyword else {
            DDLogDebug("Keyword unexpectedly nil")
            return
        }
        
        DDLogDebug("Attempting to fetch photos with keyword '\(keyword)'...")
        
        APIService.fetchPhotos(with: keyword, page: page) { responseStatus in
            
            switch responseStatus {
                
            case .success(let photos, let totalPages):
                DDLogDebug("Successfully fetched \(photos.count) photo results")
                
                self.photos += photos
                self.page += 1
                self.totalPages = totalPages

            case .error(let errorMessage):
                self.showSnackBar(with: errorMessage)
            }
        }
    }
    
    // MARK: - Error Handling
    
    func showSnackBar(with messageText: String?) {
      
        MDCSnackbarManager.show(
            MDCSnackbarMessage(
                text: messageText ?? Constants.errorMessage
            )
        )
    }
    
    // MARK: - Helpers
    
    private func scrollToTop() {
        
        resultsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    private func presentEnlargedPhoto(_ result: Photo) {
        
        UIImageView().sd_setImage(with: result.imageURL) { image, _, _, _ in
            
            self.present(
                EnlargedPhotoViewController(
                    image: image,
                    subtitle: result.title
                ),
                animated: true,
                completion: nil
            )
        }
    }
}
