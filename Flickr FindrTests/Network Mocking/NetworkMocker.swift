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

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

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
    
    static func stub(path: String, method: HTTPMethod, status: ResponseStatus) {
        
        let stubSignature = RequestSignature(path: path, method: method)
        let testBlock = compareRequestSignatures(stubSignature)
                
        OHHTTPStubs.stubRequests(passingTest: testBlock) { _ in
                        
            let response = OHHTTPStubsResponse(
                fileAtPath: attemptToGetFilePath(withFilename: status.jsonFilePath),
                statusCode: status.code,
                headers: [:]
            )
            
            response.responseTime = 0.1
            return response
        }
    }
    
    // MARK: - General Add/Remove All
    
    static func stubAllRequests() {
        
        stubSearchWithSuccess()
    }
    
    static func removeAllStubs() {
        
        OHHTTPStubs.removeAllStubs()
    }
    
    // MARK: - Helpers
    
    static private func attemptToGetFilePath(withFilename filename: String) -> String {
        
        guard let filePath = OHPathForFileInBundle(filename, Bundle(for: self)) else {
            fatalError("File with filename not found: \(filename)")
        }
        
        return filePath
    }
    
    static private func compareRequestSignatures(_ stubSignature: RequestSignature) -> OHHTTPStubsTestBlock {
        
        return { request in
            
            let requestSignature = RequestSignature(request: request)
            
            return requestSignature == stubSignature
        }
    }
}
