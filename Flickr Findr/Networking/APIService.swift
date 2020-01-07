//
//  APIService.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import WebKit

enum ResponseStatus {
    
    case success([Photo], Int)
    case error(String?)
}

typealias JSON = [String: Any]

class APIService {
    
    typealias ResponseHandler = ((ResponseStatus) -> Void)
    typealias Keys = JSONKeys.Request

    // MARK: - Constants
    
    static let apiKey = "1508443e49213ff84d566777dc211f2a"
    private static let defaultSession = URLSession.shared
    private static var dataTask: URLSessionDataTask?
    
    // MARK: - Helper Methods
        
    static func sendJSONRequest(to path: String, parameters: JSON, completion: @escaping ResponseHandler) {
            
        dataTask?.cancel()
            
        guard var urlComponents = URLComponents(string: Path.baseURL) else {
            DDLogDebug("URL Components unexpectedly nil")
            return
        }
            
        urlComponents.query = query(for: parameters, path: path)
        
        guard let url = urlComponents.url else {
            DDLogDebug("URL Components URL unexpectedly nil")
            return
        }
      
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            
            defer {
                self.dataTask = nil
            }
                
            DispatchQueue.main.async {
                
                guard let data = data else {
                    DDLogDebug("Error decoding response: \(String(describing: error?.localizedDescription))")
                    completion(.error(nil))
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options:[]) as? JSON,
                       let photosJSON = json[JSONKeys.Response.photos] as? JSON,
                       let totalPages = photosJSON[JSONKeys.Response.pages] as? Int {
                        
                        let photos = Photo.parse(using: json)
                        completion(.success(photos, totalPages))
                    }
                    else if let json = try JSONSerialization.jsonObject(with: data, options:[]) as? JSON,
                        let errorMessage = json[JSONKeys.Response.message] as? String {
                        DDLogDebug("Error from API: \(errorMessage)")
                        completion(.error(errorMessage))
                        return
                    }
                } catch let parseError as NSError {
                    DDLogDebug("Error parsing JSON: \(parseError.localizedDescription)")
                    completion(.error(nil))
                }
            }
        }
        
        dataTask?.resume()
    }
    
    private static func query(for parameters: JSON, path: String) -> String {
        
        var queryString = "\(Keys.method)=\(path)&\(Keys.apiKey)=\(apiKey)"
        
        if let text = parameters[Keys.text] as? String {
            
            queryString += "&\(Keys.text)=\(text)"
        }
        if let perPage = parameters[Keys.perPage] {
            
            queryString += "&\(Keys.perPage)=\(perPage)"
        }
        if let page = parameters[Keys.page] {
           
            queryString += "&\(Keys.page)=\(page)"
        }
        
        queryString += "&\(Keys.format)=json&\(Keys.noJSONCallback)=1"
        
        return queryString
    }
}

extension APIService {
    
    static func fetchPhotos(with keyword: String, page: Int, completion: @escaping ResponseHandler) {

        let params: JSON = [
            Keys.text: keyword,
            Keys.perPage: 25,
            Keys.page: page,
            Keys.format: "json",
            Keys.noJSONCallback: 1
        ]
        
        sendJSONRequest(
            to: Path.search,
            parameters: params,
            completion: completion
        )
    }
}
