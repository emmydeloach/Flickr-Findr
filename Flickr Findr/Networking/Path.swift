//
//  Path.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

struct Path {
 
    static let baseURL = "https://www.flickr.com/services/rest/"
    
    static let getRecent = "flickr.photos.getRecent"
    static let search = "flickr.photos.search"
    
    static func imagePath(photoID: String?, serverID: String?, farmID: Int?, secret: String?) -> String {
        
        guard let photoID = photoID, let serverID = serverID, let farmID = farmID, let secret = secret else { return "" }
        
        return "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
    }
}
