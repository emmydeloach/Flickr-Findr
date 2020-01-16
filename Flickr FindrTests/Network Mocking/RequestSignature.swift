//
//  RequestSignature.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/15/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

struct RequestSignature: Equatable {

    let path: String
    let method: HTTPMethod
    
    init(path: String, method: HTTPMethod) {
        
        self.path = path
        self.method = method
    }
    
    init(request: URLRequest) {
        
        let path = request.url?.path ?? ""
        let method = HTTPMethod(rawValue: request.httpMethod ?? "") ?? .get
        
        self.init(path: path, method: method)
    }
    
    static func == (lhs: RequestSignature, rhs: RequestSignature) -> Bool {
        
        return lhs.path == rhs.path && lhs.method == rhs.method
    }
}
