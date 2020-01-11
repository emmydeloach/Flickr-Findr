//
//  RecentSearchesViewController.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/10/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

class RecentSearchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    
    @IBOutlet weak var recentSearchesTableView: UITableView!
    
    // MARK: - Properties
    
    weak var delegate: RecentSearchable?
    
    // MARK: - Init
    
    init(delegate: RecentSearchable) {
        
        self.delegate = delegate
        
        super.init(nibName: String(describing: RecentSearchesViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    // MARK: - Setup
    
    private func setUpTableView() {
        
        recentSearchesTableView.delegate = self
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.isScrollEnabled = false
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return delegate?.recentSearches.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = delegate?.recentSearches[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didSelectRecentSearch(delegate?.recentSearches[indexPath.row])
    }
}
