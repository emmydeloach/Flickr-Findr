//
//  Photo.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/4/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

class Photo {
    
    // MARK: - Properties

    let title: String
    var imageURL: URL?
    
    // MARK: - Initialization
    
    init(title: String, imageURL: URL?) {
                          
        self.title = title
        self.imageURL = imageURL
    }
    
    @discardableResult
    convenience init?(json: JSON) {
        
        typealias Keys = JSONKeys.Response.Photo
        
        guard let title = json[Keys.title] as? String else {
            DDLogDebug("Photo title found unexpectedly nil while parsing")
            return nil
        }
        
        let imagePath = Path.imagePath(
            photoID: json[Keys.id] as? String,
            serverID: json[Keys.serverID] as? String,
            farmID: json[Keys.farmID] as? Int,
            secret: json[Keys.secret] as? String
        )
        
        self.init(
            title: title,
            imageURL: URL(string: imagePath)
        )
    }
    
    // MARK: - Helpers
    
    @discardableResult
    class func parse(using json: JSON) -> [Photo] {
        
        typealias Keys = JSONKeys.Response
        
        guard let photos = json[Keys.photos] as? JSON, let results = photos[Keys.photoResults] as? [JSON] else {
            DDLogDebug("Expected Photo JSON while parsing but unexpectedly found nil")
            return []
        }
        
        return results.compactMap { Photo(json: $0) }
    }
}
