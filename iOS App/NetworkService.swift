//
//  NetworkService.swift
//  iOS App
//
//  Created by Ankit Mendiratta on 29/05/24.
//

import Foundation

class NetworkService {
    
    enum APIError: Error {
        case invalidURL
        case requestFailed
        case invalidData
        case decodingError
    }
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchFeedData(page: Int, completion: @escaping (Result<[ListModel], APIError>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=10"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error != nil ? .requestFailed : .invalidData))
                return
            }
            
            do {
                let listModels = try JSONDecoder().decode([ListModel].self, from: data)
                completion(.success(listModels))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
