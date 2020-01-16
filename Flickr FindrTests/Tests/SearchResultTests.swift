//
//  SearchResultTests.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/15/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import UIKit
import XCTest
import MetovaTestKit

@testable import Flickr_Findr

class SearchResultTests: BaseTestCase {
    
    func testDecode() throws {
        
        guard let mockData = loadDataFromFile(named: "search_response_success") else {
            XCTFail("Failed to load data from JSON file")
            return
        }

        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: mockData)

        XCTAssertEqual(searchResponse.status, "ok")
        
        let results = searchResponse.results
        XCTAssertEqual(results.results.count, 10)
        XCTAssertEqual(results.totalPages, 15581)
        
        let result = results.results[0]
        XCTAssertEqual(result.title, "Over the edge.")
        XCTAssertNotNil(result.imageURL)
        XCTAssertEqual(result.imageURL?.absoluteString, "https://farm66.staticflickr.com/65535/49384787891_f3fe7071ee.jpg")
    }
}
