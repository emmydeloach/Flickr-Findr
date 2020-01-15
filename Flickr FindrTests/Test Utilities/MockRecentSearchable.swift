//
//  MockRecentSearchable.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/14/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest

@testable import Flickr_Findr

class MockRecentSearchable: RecentSearchable {
    
    // MARK: - Test Properties
    
    private let _recentSearches: [String]
    
    // MARK: - Init
    
    init(recentSearches: [String]) {
        
        self._recentSearches = recentSearches
    }
    
    // MARK: - RecentSearchable Delegate
    
    var recentSearches: [String] { return _recentSearches }
    
    func didSelectRecentSearch(_ recentSearch: String?) { }
}
