//
//  MockJSONDecoderService.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 12/10/2024.
//

import Foundation
@testable import GameOfThrones

class MockJSONDecoderService: JSONDecoderServiceProtocol {
    var mockData: Data?

    func decode<T: Decodable>(_: Data, as _: T.Type) throws -> T {
        guard let mockData = mockData else {
            throw MockError.decodingFailed
        }
        return try JSONDecoder().decode(T.self, from: mockData)
    }
}

enum MockError: Error {
    case decodingFailed
}
