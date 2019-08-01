//
//  NetworkDataFetcher.swift
//  ViewController. Single Responsibility Principle.
//
//  Created by Алексей Пархоменко on 13.06.2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    var networking: Networking
    private var jsonResponse: Any?
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResult?) -> ()) {
        fetchGenericJSONData(urlString: searchTerm, response: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void) {
        print(T.self)
        networking.request(searchTerm: urlString) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
            
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            guard let jsonResponse = jsonResponse as? [String: Any],
                let results = jsonResponse["results"] as? [Any] else {
                    return nil
            }
//            print(results)
            
            let objects = try decoder.decode(type.self, from: data)
    
//            print(objects)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
