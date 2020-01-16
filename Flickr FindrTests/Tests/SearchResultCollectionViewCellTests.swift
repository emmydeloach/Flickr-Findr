//
//  SearchResultCollectionViewCellTests.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/14/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest
import MetovaTestKit

@testable import Flickr_Findr

class SearchResultCollectionViewCellTests: BaseTestCase {
 
    // MARK: - Test Properties
    
    var testCell: SearchResultCollectionViewCell!
    var testResult: SearchResult!
    
    // MARK: - Setup & Tear Down
    
    override func setUp() {
        
        super.setUp()
        
        do {
            testCell = SearchResultCollectionViewCell.loadFromNib()
            testResult = try SearchResult.createTestSearchResult()
            testCell.awakeFromNib()
        }
        catch {
            XCTFail("Unable to instantiate mock Search Result with error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Tests
    
    func testNoBrokenConstraints() {
        
        MTKAssertNoBrokenConstraints {
            testCell.awakeFromNib()
        }
    }
    
    func testSetUpTitleLabel() throws {
                   
        testCell.load(testResult)
        
        MTKWaitThenContinueTest(after: 0.1)
        
        XCTAssertEqual(testCell.titleLabel.text, "Test Title")
        XCTAssertEqual(testCell.titleLabel.textColor, .black)
        XCTAssertEqual(testCell.titleLabel.font, UIFont(name: "DIN Alternate", size: 14))
    }
    
    func testSetUpImageView() {
        
        testCell.load(testResult)
        
        MTKWaitThenContinueTest(after: 0.1)
        
        assertEqualImages(testCell.imageView.image, UIImage(named: Constants.errorIcon))
        XCTAssertEqual(testCell.imageView.contentMode, .scaleAspectFill)
    }
}
