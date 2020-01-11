//
//  SearchResult.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/4/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

class SearchResult: Decodable {
    
    // MARK: - Properties
    
    let title: String
    var imageURL: URL? {
        return URL(string: "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg")
    }
    
    private let photoID: String
    private let serverID: String
    private let farmID: Int
    private let secret: String
    
    // MARK: - Coding
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case photoID = "id"
        case serverID = "server"
        case farmID = "farm"
        case secret
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.photoID = try container.decode(String.self, forKey: .photoID)
        self.serverID = try container.decode(String.self, forKey: .serverID)
        self.farmID = try container.decode(Int.self, forKey: .farmID)
        self.secret = try container.decode(String.self, forKey: .secret)
    }
}
