//
//  SearchResult+TestHelpers.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/14/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

@testable import Flickr_Findr

extension SearchResult {
    
    static func createTestSearchResult(title: String = "Test Title",
                                       photoID: String = "Test_Photo_ID",
                                       serverID: String = "Test_Server_ID",
                                       farmID: Int = 123,
                                       secret: String = "Test_Secret") throws -> SearchResult {
        
        let searchResultJSON: JSON = [
            "title": title,
            "id": photoID,
            "server": serverID,
            "farm": farmID,
            "secret": secret
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: searchResultJSON, options: [])
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)

        return searchResult
    }
}
