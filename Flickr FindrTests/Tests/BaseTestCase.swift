//
//  BaseTestCase.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest
import MaterialComponents.MaterialSnackbar

@testable import Flickr_Findr

class BaseTestCase: XCTestCase {

    // MARK: - Setup & Tear Down
    
    override func setUp() {

        super.setUp()
        
        NetworkMocker.stubAllRequests()
    }

    override func tearDown() {

        NetworkMocker.removeAllStubs()
        
        super.setUp()
    }
    
    // MARK: - Helpers
    
    func assertEqualImages(_ image1: UIImage?, _ image2: UIImage?, file: StaticString = #file, line: UInt = #line) {
        
        guard let image1 = image1, let image2 = image2, let data1 = image1.pngData(), let data2 = image2.pngData() else {
            XCTFail("One or more images unexpectedly nil", file: file, line: line)
            return
        }
        
        guard data1 == data2 else {
            XCTFail("Image \(image1) is not equal to \(image2)", file: file, line: line)
            return
        }
    }
    
    func verifySnackBarPresented(file: StaticString = #file, line: UInt = #line) {
        
        let expectation = self.expectation(description: "Should show error snackbar")
        
        XCTAssertTrue(MDCSnackbarManager.hasMessagesShowingOrQueued(), file: file, line: line)
        expectation.fulfill()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
