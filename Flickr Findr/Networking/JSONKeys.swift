//
//  JSONKeys.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/4/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

struct JSONKeys {
    
    struct Request {
        
        static let method = "method"
        static let apiKey = "api_key"
        static let text = "text"
        static let perPage = "per_page"
        static let page = "page"
        static let format = "format"
        static let noJSONCallback = "nojsoncallback"
    }
    
    struct Response {
        
        static let photos = "photos"
        static let page = "page"
        static let pages = "pages"
        static let perPage = "perpage"
        static let photoResults = "photo"
        static let status = "stat"
        static let message = "message"
        
        struct Photo {

            static let title = "title"
            static let id = "id"
            static let serverID = "server"
            static let farmID = "farm"
            static let secret = "secret"
        }
    }
}
