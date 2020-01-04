//
//  APIService.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

import WebKit
import CocoaLumberjack

typealias JSON = [String: Any]

class APIService {
    
    typealias ResponseHandler = (([Photo], Error?) -> Void)
    typealias Keys = JSONKeys.Request

    // MARK: - Constants
    
    static let apiKey = "1508443e49213ff84d566777dc211f2a"
    private static let defaultSession = URLSession(configuration: .default) // Which session should we use?
    private static let session = URLSession.shared
    private static var dataTask: URLSessionDataTask?
    
    // MARK: - Helper Methods
        
    static func sendJSONRequest(to path: String, parameters: JSON, completion: @escaping ResponseHandler) {
            
        dataTask?.cancel()
            
        if var urlComponents = URLComponents(string: Path.baseURL) {
            
            urlComponents.query = query(for: parameters, path: path)
            
            guard let url = urlComponents.url else {
                DDLogError("Whoopsy daisy")
                return
            }
          
            dataTask = defaultSession.dataTask(with: url) { data, _, error in
                
                defer {
                    self.dataTask = nil
                }
                    
                guard /*let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,*/ let data = data else {
                    completion([], error)
                    DDLogError("Error decoding response: \(error?.localizedDescription)")
                    return
                }

                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options:[]) as? JSON else {
                        DDLogError("Error parsing JSON: \(error?.localizedDescription)")
                        completion([], error)
                        return
                    }
                    
                    let photos = Photo.parse(using: json)
                    completion(photos, error)
                } catch let parseError as NSError {
                    DDLogError("Error parsing JSON: \(parseError.localizedDescription)")
                    completion([], parseError)
                }
            }
            
            dataTask?.resume()
        }
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
    
    // Default call on home screen
    static func getPopular(_ page: Int, perPage: Int = 25, completion: @escaping ResponseHandler) {
        
        let params: JSON = [
            Keys.perPage: perPage,
            Keys.page: page,
            Keys.format: "json",
            Keys.noJSONCallback: 1
        ]
        
        sendJSONRequest(to: Path.getPopular, parameters: params, completion: completion)
    }
    
    static func searchPhotos(with keyword: String, page: Int, perPage: Int = 25, completion: @escaping ResponseHandler) {
        
        let params: JSON = [
            Keys.text: keyword,
            Keys.perPage: perPage,
            Keys.page: page,
            Keys.format: "json",
            Keys.noJSONCallback: 1
        ]
        
        sendJSONRequest(to: Path.search, parameters: params, completion: completion)
    }
}
