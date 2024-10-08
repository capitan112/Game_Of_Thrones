//
//  NetworkService.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import PromiseKit

protocol NetworkServiceProtocol {
    func fetchHouses() throws -> Promise<[House]>
}

enum NetworkError: Error {
    case badUrl
    case decodingError(Error)
    case networkError(Error)
}

class NetworkService: NetworkServiceProtocol {
    
    func fetchHouses() throws -> Promise<[House]> {
        guard let url = URL(string: "https://anapioficeandfire.com/api/houses") else {
            throw NetworkError.badUrl
        }
        
        return fetch(with: url)
    }
    
    
    private func fetch<T: Decodable>(with url: URL) -> Promise<[T]> {
        return Promise { seal in
        
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    seal.reject(NetworkError.networkError(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                     seal.reject(NetworkError.networkError(NSError(domain: "",
                                                                   code: httpResponse.statusCode,
                                                                   userInfo: [NSLocalizedDescriptionKey: "Invalid status code: \(httpResponse.statusCode)"])))
                     return
                }
                
                guard let data = data else {
                    seal.reject(NetworkError.networkError(NSError(domain: "",
                                                                  code: -1,
                                                                  userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
                

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                
                do {
                    let result = try decoder.decode([T].self, from: data)
                    seal.fulfill(result)
                } catch {
                    seal.reject(NetworkError.decodingError(error))
                }
            }.resume()
        }
    }
}
