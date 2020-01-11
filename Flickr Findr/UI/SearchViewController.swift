//
//  SearchViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import SDWebImage
import MaterialComponents.MaterialSnackbar

protocol RecentSearchable: class {
    
    var recentSearches: [String] { get } // Limited to 5
    func didSelectRecentSearch(_ recentSearch: String?)
}

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ResultsLayoutDelegate, UISearchBarDelegate, RecentSearchable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var results: [SearchResult] = [] {
        didSet {
            resultsCollectionView.reloadData()
            resultsCollectionView.isHidden = results.isEmpty
        }
    }
    
    private var keyword: String? {
        didSet {
            fetchPhotoResults()
        }
    }
    
    private var page = 1
    private var totalPages = 0
    var recentSearches: [String] = []
    
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
        
        resultsCollectionView.register(cellType: SearchResultCollectionViewCell.self)
        
        if let layout = resultsCollectionView.collectionViewLayout as? ResultsLayout {
         
            layout.delegate = self
        }
    }
    
    // MARK: - Search Bar Delegate
    
    /*
     Listen for search bar tap
        if !recentSearches.isEmpty {
            present recent searches vc
        }
     */
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Reset counts
        page = 1
        totalPages = 0
        results = []
        keyword = searchBar.text
        view.endEditing(true)
        scrollToTop()
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchResultCollectionViewCell.self)
        
        maybeFetchMoreResults(indexPath)
        cell.load(
            results[indexPath.item]
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return SearchResultCollectionViewCell.defaultHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presentEnlargedPhoto(
            results[indexPath.item]
        )
    }
    
    // MARK: - Networking

    private func fetchPhotoResults() {
        
        guard let keyword = keyword else { // TODO: add to or reorder recent searches
            DDLogDebug("Keyword unexpectedly nil")
            return
        }
        
        DDLogDebug("Attempting to fetch photos with keyword '\(keyword)'...")
        
        APIService.fetchPhotos(with: keyword, page: page) { responseStatus in
            
            switch responseStatus {
                
            case .success(let results, let totalPages):
                DDLogDebug("Successfully fetched \(results.count) photo results")
                
                self.results += results
                self.page += 1
                self.totalPages = totalPages

            case .error(let errorMessage):
                self.showSnackBar(with: errorMessage)
            }
        }
    }
    
    func didSelectRecentSearch(_ recentSearch: String?) {
        
        keyword = recentSearch
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
    
    private func maybeFetchMoreResults(_ indexPath: IndexPath) {
     
        let nearEndOfResults = indexPath.item == results.count - 1
        let moreResultsToFetch = totalPages > page
        
        guard nearEndOfResults && moreResultsToFetch else { return }
            
        DDLogInfo("Nearing end of results; fetching more")
        fetchPhotoResults()
    }
    
    private func presentEnlargedPhoto(_ result: SearchResult) {
                    
        present(
            EnlargedPhotoViewController(
                result: result
            ),
            animated: true,
            completion: nil
        )
    }
}
