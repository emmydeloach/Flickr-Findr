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
    
    var recentSearches: [String] { get }
    func didSelectRecentSearch(_ recentSearch: String?)
}

enum Orientation {
    
    case portrait
    case landscape
    
    var columnCount: Int {
        switch self {
        case .portrait: return 3
        case .landscape: return 8
        }
    }
}

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, RecentSearchable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    @IBOutlet weak var recentSearchesContainerView: UIView!
    
    // MARK: - Constants
    
    private let recentSearchesMax = 5

    // MARK: - Properties
    
    var orientation: Orientation = .portrait
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
    
    var page = 1
    var totalPages = 0
    
    private var recentSearchesViewController: RecentSearchesViewController?
    var recentSearches: [String] = [] {
        didSet {
            recentSearchesViewController?.recentSearchesTableView.reloadData()
        }
    }
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            
            self.updateLayoutsForOrientationChange(newOrientation: UIDevice.current.orientation)
        }
    }
    
    // MARK: - Setup
    
    private func setUpUI() {
        
        setUpSearchBar()
        setUpCollectionView()
        setUpRecentSearches()
        
        keyword = Constants.defaultSearchTerm
    }
    
    private func setUpSearchBar() {
        
        searchBar.delegate = self
        searchBar.searchTextField.clearsOnBeginEditing = true
    }
    
    private func setUpCollectionView() {
        
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        
        resultsCollectionView.register(cellType: SearchResultCollectionViewCell.self)
    }
    
    private func setUpRecentSearches() {
        
        recentSearchesViewController = RecentSearchesViewController(delegate: self)
        
        guard let recentSearchesViewController = recentSearchesViewController else { return }
        
        recentSearchesContainerView.addSubview(recentSearchesViewController.view)
        recentSearchesViewController.view.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if !recentSearches.isEmpty {
            
            presentRecentSearches()
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        performNewSearch()
    }
    
    // MARK: - Collection View
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        recentSearchesContainerView.isHidden = true
        view.endEditing(true)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presentEnlargedPhoto(
            results[indexPath.item]
        )
    }
    
    // MARK: - Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let floatColumnCount = CGFloat(orientation.columnCount)
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let buffer = (flowLayout?.minimumInteritemSpacing ?? 0) * (floatColumnCount - 1)

        return CGSize(
            width: (collectionView.frame.size.width - buffer) / floatColumnCount,
            height: SearchResultCollectionViewCell.defaultHeight
        )
    }
    
    // MARK: - Networking

    private func fetchPhotoResults() {
        
        guard let keyword = keyword else {
            DDLogDebug("Keyword unexpectedly nil")
            return
        }
        
        updateRecentSearches(with: keyword)
        
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
    
    private func performNewSearch() {
        
        // Reset counts
        page = 1
        totalPages = 0
        results = []
        keyword = searchBar.text

        view.endEditing(true)
        recentSearchesContainerView.isHidden = true
        scrollToTop()
    }
    
    func didSelectRecentSearch(_ recentSearch: String?) {
        
        searchBar.text = recentSearch
        performNewSearch()
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
    
    private func updateLayoutsForOrientationChange(newOrientation: UIDeviceOrientation) {
        
        resultsCollectionView.collectionViewLayout.invalidateLayout()
        
        switch newOrientation {
        case .portrait:
            orientation = .portrait
        case .landscapeLeft, .landscapeRight:
            orientation = .landscape
        default:
            DDLogError("Attempting to update layout for unknown orientation")
        }
    }
    
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
    
    private func presentRecentSearches() {
        
        recentSearchesContainerView.isHidden = false
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
    
    private func updateRecentSearches(with keyword: String) {
          
        guard keyword != Constants.defaultSearchTerm else { return }
        
        if recentSearches.contains(keyword), let index = recentSearches.firstIndex(of: keyword) {
            
            // Move to top if already in list
            recentSearches.remove(at: index)
        }
        
        recentSearches.insert(keyword, at: 0)
        
        if recentSearches.count == recentSearchesMax + 1 {
            
            // Trim if list has surpassed maximum
            recentSearches.remove(at: recentSearchesMax)
        }
    }
}
