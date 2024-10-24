//
//  NetworkService.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import PromiseKit

protocol NetworkServiceProtocol {
    init(decoderService: JSONDecoderServiceProtocol)
    func fetchHouses() throws -> Promise<[House]>
    func fetchBooks() throws -> Promise<[Book]>
    func fetchCharacters() throws -> Promise<[Character]>
}

enum NetworkError: Error, Equatable {
    case badUrl
    case decodingError(Error)
    case networkError(Error)
    case invalidStatusCode(Int)
    case noData

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badUrl, .badUrl):
            return true
        case (.noData, .noData):
            return true
        case let (.invalidStatusCode(lhsCode), .invalidStatusCode(rhsCode)):
            return lhsCode == rhsCode
        case let (.decodingError(lhsError), .decodingError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case let (.networkError(lhsError), .networkError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

class NetworkService: NetworkServiceProtocol {
    private let decoderService: JSONDecoderServiceProtocol

    required init(decoderService: JSONDecoderServiceProtocol = JSONDecoderService()) {
        self.decoderService = decoderService
    }

    func fetchCharacters() throws -> Promise<[Character]> {
        guard let url = urlFromParameters(path: RequestConstant.Endpoints.characters) else {
            throw NetworkError.badUrl
        }

        return fetch(from: url)
    }

    func fetchHouses() throws -> Promise<[House]> {
        guard let url = urlFromParameters(path: RequestConstant.Endpoints.houses) else {
            throw NetworkError.badUrl
        }

        return fetch(from: url)
    }

    func fetchBooks() throws -> Promise<[Book]> {
        guard let url = urlFromParameters(path: RequestConstant.Endpoints.books) else {
            throw NetworkError.badUrl
        }

        return fetch(from: url)
    }

    private func urlFromParameters(path: String) -> URL? {
        guard !path.isEmpty else { return nil }

        var components = URLComponents()
        components.scheme = RequestConstant.Server.scheme
        components.host = RequestConstant.Server.host
        components.path = path

        return components.url
    }

    private func fetch<T: Decodable>(from url: URL) -> Promise<[T]> {
        return Promise { seal in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    seal.reject(NetworkError.networkError(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    seal.reject(NetworkError.invalidStatusCode(httpResponse.statusCode))
                    return
                }

                guard let data = data else {
                    seal.reject(NetworkError.noData)
                    return
                }

                do {
                    let result: [T] = try self.decoderService.decode(data, as: [T].self)
                    seal.fulfill(result)
                } catch {
                    seal.reject(NetworkError.decodingError(error))
                }
            }.resume()
        }
    }
}
