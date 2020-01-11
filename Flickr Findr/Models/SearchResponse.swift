//
//  SearchResponse.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/10/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

class SearchResponse: Decodable {
    
    class Results: Decodable {
        
        let totalPages: Int
        let results: [SearchResult]
        
        enum CodingKeys: String, CodingKey {
            
            case totalPages = "pages"
            case results = "photo"
        }
        
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let rawTotal = try container.decode(Int.self, forKey: .totalPages)
            self.totalPages = Int(rawTotal)
            self.results = try container.decode([SearchResult].self, forKey: .results)
            
        }
    }
    
    let results: Results
    let status: String
    
    enum CodingKeys: String, CodingKey {
        
        case results = "photos"
        case status = "stat"
    }
}
