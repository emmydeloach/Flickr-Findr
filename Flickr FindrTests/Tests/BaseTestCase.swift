//
//  BaseTestCase.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest

@testable import Flickr_Findr

class BaseTestCase: XCTestCase {

    override func setUp() {

        super.setUp()
        
        NetworkMocker.stub(status: .success)
    }

    override func tearDown() {

        NetworkMocker.removeAllStubs()
        
        super.setUp()
    }
}
