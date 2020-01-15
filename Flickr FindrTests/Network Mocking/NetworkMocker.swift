//
//  NetworkMocker.swift
//  Flickr FindrTests
//
//  Created by Emmy DeLoach on 1/14/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import Flickr_Findr

class NetworkMocker {
    
    enum ResponseStatus {
        
        case success
        case error
        
        var jsonFilePath: String {
            switch self {
            case .success: return "search_response_success.json"
            case .error: return "search_response_failure.json"
            }
        }
        
        var code: Int32 {
            switch self {
            case .success: return 200
            case .error: return 400
            }
        }
    }
    
    static func stub(status: ResponseStatus) {
        
        guard let stubPath = OHPathForFileInBundle(status.jsonFilePath, Bundle(for: self)) else {
            DDLogWarn("Network mocker file path unexpectedly nil")
            return
        }

        OHHTTPStubs.stubRequests(passingTest: isHost(Path.search)) { _ in

            return OHHTTPStubsResponse(
                fileAtPath: stubPath,
                statusCode: status.code,
                headers: ["Content-Type":"application/json"]
            )
        }
    }
    
    static func removeAllStubs() {
        
        OHHTTPStubs.removeAllStubs()
    }
}
