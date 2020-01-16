//
//  SearchViewControllerTests.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/14/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest
import MetovaTestKit

@testable import Flickr_Findr

class SearchViewControllerTests: BaseTestCase {
    
    // MARK: - Test Properties
    
    var testVC: SearchViewController!
    
    // MARK: - Setup & Tear Down
    
    override func setUp() {
        
        super.setUp()
      
        testVC = SearchViewController()
        testVC.loadView()
        testVC.viewDidLoad()
    }
    
    // MARK: - Tests
    
    func testNoBrokenConstraints() {
        
        MTKAssertNoBrokenConstraints {
            testVC.viewDidLoad()
        }
    }
    
    func testSetUpSearchBar() {
        
        XCTAssertTrue(testVC.searchBar.delegate === testVC)
        XCTAssertTrue(testVC.searchBar.searchTextField.clearsOnBeginEditing)
    }
    
    func testSetUpCollectionView() {
        
        MTKWaitThenContinueTest(after: 0.2)
        
        XCTAssertTrue(testVC.resultsCollectionView.delegate === testVC)
        XCTAssertTrue(testVC.resultsCollectionView.dataSource === testVC)
        XCTAssertEqual(testVC.collectionView(testVC.resultsCollectionView, numberOfItemsInSection: 0), 10)
        MTKTestCell(in: testVC.resultsCollectionView, at: IndexPath(item: 0, section: 0), as: SearchResultCollectionViewCell.self) { _ in }
    }
    
    // MARK: - Search
    
    func testSearch() {
        
        XCTAssertTrue(testVC.results.isEmpty)
        XCTAssertEqual(testVC.page, 1)
        XCTAssertEqual(testVC.totalPages, 0)
        
        NetworkMocker.stubSearchWithSuccess()
        MTKWaitThenContinueTest(after: 0.2)

        XCTAssertEqual(testVC.results.count, 10)
        XCTAssertEqual(testVC.page, 2)
        XCTAssertEqual(testVC.totalPages, 15581)
    }
    
    func testSearchFailed() {
        
        NetworkMocker.stubSearchWithError()
        MTKWaitThenContinueTest(after: 0.2)

        verifySnackBarPresented()
    }
    
    func testFetchMoreResults() {
        
        XCTAssertEqual(testVC.page, 1)
        
        NetworkMocker.stubSearchWithSuccess()
        MTKWaitThenContinueTest(after: 0.2)

        XCTAssertEqual(testVC.page, 2)

        _ = testVC.collectionView(testVC.resultsCollectionView, cellForItemAt: IndexPath(item: 9, section: 0)) // Trigger more results fetch by dequeuing last item
        MTKWaitThenContinueTest(after: 0.2)

        XCTAssertEqual(testVC.page, 3)
    }
    
    // MARK: - Recent List
    
    func testNewSearchesAreAddedToRecentList() {
        
        XCTAssertTrue(testVC.recentSearches.isEmpty)
        
        search("Jerry")
        
        XCTAssertEqual(testVC.recentSearches, ["Jerry"])
    }
    
    func testRecentListMax() {
        
        XCTAssertTrue(testVC.recentSearches.isEmpty)
        
        search("Jerry")
        search("George")
        search("Elaine")
        search("Kramer")
        search("Newman")
        search("Uncle Leo") // Should only save last 5 recent searches (FIFO)

        XCTAssertEqual(testVC.recentSearches, ["Uncle Leo", "Newman", "Kramer", "Elaine", "George"])
    }
    
    func testRecentSearchesReordersRepeats() {
        
        XCTAssertTrue(testVC.recentSearches.isEmpty)
        
        search("Jerry")
        search("George")
        search("Elaine")
        search("Kramer")
        search("Newman")
        
        XCTAssertEqual(testVC.recentSearches, ["Newman", "Kramer", "Elaine", "George", "Jerry"])
        
        search("George") // Should get moved to the top of the list

        XCTAssertEqual(testVC.recentSearches, ["George", "Newman", "Kramer", "Elaine", "Jerry"])
    }
    
    func testRecentSearchesDisplayedOnSearchBarTap() {
        
        XCTAssertTrue(testVC.recentSearchesContainerView.isHidden)
        
        search("Monks") // Populate recent searches
        _ = testVC.searchBarShouldBeginEditing(testVC.searchBar)
        
        XCTAssertFalse(testVC.recentSearchesContainerView.isHidden)
    }
    
    func testRecentSearchesHiddenOnSearch() {
        
        XCTAssertTrue(testVC.recentSearchesContainerView.isHidden)
        
        search("Monks") // Populate recent searches
        _ = testVC.searchBarShouldBeginEditing(testVC.searchBar)
        
        XCTAssertFalse(testVC.recentSearchesContainerView.isHidden)

        testVC.searchBarSearchButtonClicked(testVC.searchBar)

        XCTAssertTrue(testVC.recentSearchesContainerView.isHidden)
    }
    
    // MARK: - Helpers
    
    func search(_ keyword: String) {
        
        testVC.searchBar.text = keyword
        testVC.searchBarSearchButtonClicked(testVC.searchBar)
    }
}
