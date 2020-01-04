//
//  Photo.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/4/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import CocoaLumberjack

class Photo {
    
    // MARK: - Properties
    
    let id: String
    let title: String
        
    // MARK: - Initialization
    
    init(id: String, title: String) {
                          
        self.id = id
        self.title = title
    }
    
    @discardableResult
    convenience init?(json: JSON) {
        
        typealias Keys = JSONKeys.Response.Photo
        
        guard let id = json[Keys.id] as? String, let title = json[Keys.title] as? String else {
            DDLogError("Exepcted Photo properties but unexpectedly found nil")
            return nil
        }
        
        self.init(
            id: id,
            title: title
        )
    }
    
    // MARK: - Helpers
    
    @discardableResult
    class func parse(using json: JSON) -> [Photo] {
        
        typealias Keys = JSONKeys.Response
        
        guard let photos = json[Keys.photos] as? JSON, let results = photos[Keys.photoResults] as? [JSON] else {
            DDLogError("Exepcted Photo properties but unexpectedly found nil")
            return []
        }
        
        return results.compactMap { Photo(json: $0)}
    }
}
