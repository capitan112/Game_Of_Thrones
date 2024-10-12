//
//  MockNetworkService.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import Foundation
@testable import GameOfThrones
import PromiseKit

class MockNetworkService: NetworkServiceProtocol {
    private var decoderService: JSONDecoderServiceProtocol

    required init(decoderService: JSONDecoderServiceProtocol = JSONDecoderService()) {
        self.decoderService = decoderService
    }

    var mockHouses: [House] = []
    var mockBooks: [Book] = []
    var mockCharacters: [Character] = []

    var shouldFail = false
    var errorToReturn: NetworkError?

    func fetchHouses() throws -> Promise<[House]> {
        if shouldFail {
            if let error = errorToReturn {
                return Promise { seal in
                    seal.reject(error)
                }
            } else {
                return Promise { seal in
                    seal.reject(NetworkError.badUrl)
                }
            }
        }

        return simulateFetchResult(for: mockHouses)
    }

    func fetchBooks() throws -> Promise<[Book]> {
        if shouldFail {
            if let error = errorToReturn {
                return Promise { seal in
                    seal.reject(error)
                }
            } else {
                return Promise { seal in
                    seal.reject(NetworkError.badUrl)
                }
            }
        }

        return simulateFetchResult(for: mockBooks)
    }

    func fetchCharacters() throws -> Promise<[Character]> {
        if shouldFail {
            if let error = errorToReturn {
                return Promise { seal in
                    seal.reject(error)
                }
            } else {
                return Promise { seal in
                    seal.reject(NetworkError.badUrl)
                }
            }
        }

        return simulateFetchResult(for: mockCharacters)
    }

    private func simulateFetchResult<T>(for mockData: [T]) -> Promise<[T]> {
        return Promise { seal in
            seal.fulfill(mockData)
        }
    }
}
