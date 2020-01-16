//
//  EnlargedPhotoViewControllerTests.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/14/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest
import MetovaTestKit

@testable import Flickr_Findr

class EnlargedPhotoViewControllerTests: BaseTestCase {
 
    // MARK: - Test Properties
    
    var testVC: EnlargedPhotoViewController!
    
    // MARK: - Setup & Tear Down
    
    override func setUp() {
        
        super.setUp()
        
        do {
            let testResult = try SearchResult.createTestSearchResult()
            testVC = EnlargedPhotoViewController(result: testResult)
            testVC.loadView()
            testVC.viewDidLoad()
        }
        catch {
            XCTFail("Unable to instantiate mock Search Result with error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Tests
    
    func testNoBrokenConstraints() {
        
        MTKAssertNoBrokenConstraints {
            testVC.viewDidLoad()
        }
    }
    
    func testSetUpBlur() {
        
        guard let blurEffectView = testVC.view.subviews.first as? UIVisualEffectView,
                (blurEffectView.effect as? UIBlurEffect) != nil else {
            XCTFail("Blur effect not added")
            return
        }
        
        XCTAssertEqual(testVC.view.backgroundColor, UIColor.clear)
    }
    
    func testSetUpTitleLabel() {
        
        XCTAssertEqual(testVC.titleLabel.text, "Test Title")
        XCTAssertEqual(testVC.titleLabel.textColor, .black)
        XCTAssertEqual(testVC.titleLabel.font, UIFont(name: "DIN Alternate", size: 17))
    }
    
    func testSetUpImage() {
        
        MTKWaitThenContinueTest(after: 0.1)
        
        assertEqualImages(testVC.imageView.image, UIImage(named: Constants.errorIcon))
        XCTAssertEqual(testVC.imageView.contentMode, .scaleAspectFit)
    }
    
    func testSetUpPresentation() {
        
        XCTAssertTrue(testVC.providesPresentationContextTransitionStyle)
        XCTAssertTrue(testVC.definesPresentationContext)
    }
}
