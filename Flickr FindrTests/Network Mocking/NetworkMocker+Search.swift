//
//  NetworkMocker+Search.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/15/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

@testable import Flickr_Findr

extension NetworkMocker {
    
    static func stubSearchWithSuccess() {
        
        NetworkMocker.stub(path: Path.basePath, method: .get, status: .success)
    }
    
    static func stubSearchWithError() {
        
        NetworkMocker.stub(path: Path.basePath, method: .get, status: .error)
    }
}
