//
//  RecentSearchesViewControllerTests.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/14/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest
import MetovaTestKit

@testable import Flickr_Findr

class RecentSearchesViewControllerTests: BaseTestCase {
    
    // MARK: - Test Properties
    
    var testVC: RecentSearchesViewController!
    var testDelegate: RecentSearchable!
    
    // MARK: - Setup & Tear Down
    
    override func setUp() {
        
        super.setUp()
        
        testDelegate = MockRecentSearchable(recentSearches: [
            "Recent Search 1",
            "Recent Search 2",
            "Recent Search 3"
        ])
        testVC = RecentSearchesViewController(delegate: testDelegate)
        testVC.loadView()
        testVC.viewDidLoad()
    }
    
    // MARK: - Tests
    
    func testNoBrokenConstraints() {
        
        MTKAssertNoBrokenConstraints {
            testVC.viewDidLoad()
        }
    }

    func testSetUpTableView() {
        
        XCTAssertTrue(testVC.recentSearchesTableView.delegate === testVC)
        XCTAssertTrue(testVC.recentSearchesTableView.dataSource === testVC)
        XCTAssertFalse(testVC.recentSearchesTableView.isScrollEnabled)
        XCTAssertEqual(testVC.tableView(testVC.recentSearchesTableView, titleForHeaderInSection: 0), "Recent Searches")
        XCTAssertEqual(testVC.tableView(testVC.recentSearchesTableView, numberOfRowsInSection: 0), 3)
    }
    
    func testCellForRow() {
        
        for (index, recentSearch) in testDelegate.recentSearches.enumerated() {
            
            MTKTestCell(in: testVC.recentSearchesTableView, at: IndexPath(row: index, section: 0)) { testCell in
                
                XCTAssertEqual(testCell.textLabel?.text, recentSearch)
            }
        }
    }
}
