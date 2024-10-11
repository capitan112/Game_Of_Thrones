//
//  MockNetworkService.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import Foundation
import PromiseKit
@testable import GameOfThrones

class MockNetworkService: NetworkServiceProtocol {

    var mockHouses: [House] = []
    var mockBooks: [Book] = []
    var mockCharacters: [Character] = []
    
    var shouldFail = false
    var errorToReturn: NetworkError?

    func fetchHouses() throws -> Promise<[House]> {
        return simulateFetchResult(for: mockHouses)
    }

    func fetchBooks() throws -> Promise<[Book]> {
        return simulateFetchResult(for: mockBooks)
    }

    func fetchCharacters() throws -> Promise<[Character]> {
        return simulateFetchResult(for: mockCharacters)
    }

    // Helper method to simulate fetch results
    private func simulateFetchResult<T>(for mockData: [T]) -> Promise<[T]> {
        return Promise { seal in
            if shouldFail {
                if let error = errorToReturn {
                    seal.reject(error)
                } else {
                    seal.reject(NetworkError.networkError(NSError(domain: "MockError", code: -1, userInfo: nil)))
                }
            } else {
                seal.fulfill(mockData)
            }
        }
    }
}
