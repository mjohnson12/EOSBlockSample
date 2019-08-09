//
//  EOSIORpcApiProvider.swift
//  EOSBlockSample
//
//  Created by Mark Johnson on 8/7/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import Foundation

typealias EOSIOGetBlockDataAndResponse = (Data, EOSIOGetBlockResponse)

protocol EOSIORpcApiProviderContract {
    static func getInfo(timeout: TimeInterval, completion: @escaping (Result<EOSIOGetInfoResponse, Error>) -> ())
    static func getBlock(blockRequest: EOSIOGetBlockRequest, timeout: TimeInterval, completion: @escaping (Result<EOSIOGetBlockDataAndResponse, Error>) -> ())
}

final class EOSIORpcApiProvider: EOSIORpcApiProviderContract {
    enum EOSIORpcApiProviderError: Error, CustomStringConvertible, Equatable {
        case urlCreationFailed
        case httpRequestFailed(Int)
        case noDataReturned
        
        public var description: String {
            switch self {
            case .urlCreationFailed:
                return "URL Creation Failed"
            case .httpRequestFailed(let statusCode):
                return "Http request failed: status code = \(statusCode)"
            case .noDataReturned:
                return "No Data Returned"
            }
        }
    }
    
    private enum EOSIORpcApiProviderURLs: String {
        case baseURL = "https://api.eosnewyork.io/v1"
    }
    
    static func getEntity<T>(path: String, requestBody: Data? = nil, timeout: TimeInterval, serializer: @escaping (Data) throws -> T, completion: @escaping (Result<T, Error>) -> ()) {
        // Create the url for the provider.
        guard let url = URL(string: EOSIORpcApiProviderURLs.baseURL.rawValue+path) else {
            completion(.failure(EOSIORpcApiProviderError.urlCreationFailed))
            return
        }
        
        // Create a URLRequest used to call the provider.
        var request: URLRequest = URLRequest(url: url)
        
        // Set the headers.
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        // Set the method.
        request.httpMethod = "POST"
        
        // Set the timeout.
        request.timeoutInterval = timeout
        
        // Set the body of request.
        request.httpBody = requestBody
        
        // Create a datatask to call the provider.
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result: Result<T, Error>
            
            if let error = error {
                // The request returned an error so use that for the error to return.
                result = .failure(error)
            } else if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                // If the http status code is not within the success range return it as an error.
                result = .failure(EOSIORpcApiProviderError.httpRequestFailed(httpResponse.statusCode))
            }
            else if let data = data {
                if data.count <= 0 {
                    // No data came down from the provider even though the status code was successful.
                    result = .failure(EOSIORpcApiProviderError.noDataReturned)
                } else {
                    do {
                        // Deserialize the data into an object.
                        result = .success(try serializer(data))
                    }
                    catch {
                        // The de-serialize failed so return the caught error.
                        result = .failure(error)
                    }
                }
            } else {
                // Data is null so no data was returned even though the http status code is successful.
                result = .failure(EOSIORpcApiProviderError.noDataReturned)
            }
            
            // Call the completion block and return the de-serialized object or error.
            completion(result)
        }
        
        dataTask.resume()
    }
    
    static func deserializeInfo(jsonData: Data) throws -> EOSIOGetInfoResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(EOSIOGetInfoResponse.self, from: jsonData)
    }
    
    static func getInfo(timeout: TimeInterval, completion: @escaping (Result<EOSIOGetInfoResponse, Error>) -> ()) {
        let path: String = "/chain/get_info"
        
        return getEntity(path: path, timeout: timeout, serializer: deserializeInfo, completion: completion)
    }
    
    static func deserializeBlock(jsonData: Data) throws -> EOSIOGetBlockDataAndResponse {
        let decoder = JSONDecoder()
        let blockResponse = try decoder.decode(EOSIOGetBlockResponse.self, from: jsonData)
        return (jsonData, blockResponse)
    }
    
    static func getBlock(blockRequest: EOSIOGetBlockRequest, timeout: TimeInterval, completion: @escaping (Result<EOSIOGetBlockDataAndResponse, Error>) -> ()) {
        let path: String = "/chain/get_block"
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(blockRequest)
        
        return getEntity(path: path, requestBody: data, timeout: timeout, serializer: deserializeBlock, completion: completion)
    }
}
