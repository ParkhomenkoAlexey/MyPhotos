//
//  NetworkService.swift
//  ViewController. Single Responsibility Principle.
//
//  Created by Алексей Пархоменко on 31/05/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

protocol Networking {
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {

    var timeoutInterval = 30.0
    
    
    // построение запроса данных по URL
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {

        let parameters = prepareParameters(searchTerm: searchTerm)
        let url = URL(string: "https://api.unsplash.com/search/photos")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.query = queryParameters(parameters)
        
        var request = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
//        print("request: ", request)
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID bea9b8eca503ce9fca1a07b37dc6c9bf84f9b77b1027c4763ee46266d9cdc67f"
        return headers
    }
    
    func prepareParameters(searchTerm: String?) -> [String: Any]? {
        var parameters = [String: Any]()
        parameters["query"] = searchTerm
        parameters["page"] = 1
        parameters["per_page"] = 30
        return parameters
    }
    
    private func queryParameters(_ parameters: [String: Any]?, urlEncoded: Bool = false) -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: ".-_")
        
        var query = ""
        parameters?.forEach { key, value in
            let encodedValue: String
            if let value = value as? String {
                encodedValue = urlEncoded ? value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "" : value
            } else {
                encodedValue = "\(value)"
            }
            query = "\(query)\(key)=\(encodedValue)&"
        }
        
        print(#function, query)
        return query
    }
    
    private func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: requst, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
                
            }
        })
    }
}
