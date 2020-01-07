//
//  SearchViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import SDWebImage

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
            scrollToTop()
        }
    }
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
        
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        fetchPhotoResults()
    }
    
    // MARK: - Setup
    
    private func setUpUI() {
        
        setUpSearchBar()
        setUpCollectionView()
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
        
        fetchPhotoResults(with: searchBar.text)
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCollectionViewCell.self)
        
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

    private func fetchPhotoResults(with keyword: String? = "Iceland") {
        
        guard let keyword = keyword else {
            DDLogDebug("Keyword unexpectedly nil")
            return
        }
        
        DDLogDebug("Attempting to fetch photos with keyword '\(keyword)'...")
        
        APIService.fetchPhotos(with: keyword, page: page) { photos, error in
            
            if let error = error {
                
                DDLogWarn("Encountered error during fetch request: \(error.localizedDescription)")
                // TODO: Show toast on failed request
                return
            }
            
            DDLogDebug("Successfully fetched \(photos.count) photo results")
            
            self.photos = photos
            self.page += 1 // TODO: Add paging 
        }
    }
    
    // MARK: - Helpers
    
    private func scrollToTop() {
        
        resultsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    private func presentEnlargedPhoto(_ result: Photo) {
        
        let imageView = UIImageView()
        imageView.sd_setImage(with: result.imageURL) { image, _, _, _ in
            
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
