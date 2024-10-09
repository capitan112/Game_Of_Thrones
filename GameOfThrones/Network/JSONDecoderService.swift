//
//  JSONDecoderService.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 09/10/2024.
//

import Foundation

protocol JSONDecoderServiceProtocol {
    func decode<T: Decodable>(_ data: Data, as type: T.Type) throws -> T
}

// MARK: - JSONDecoderService
class JSONDecoderService: JSONDecoderServiceProtocol {

    private let dateFormatterService: DateFormatterServiceProtocol

    init(dateFormatterService: DateFormatterServiceProtocol = DateFormatterService()) {
        self.dateFormatterService = dateFormatterService
    }
    
    func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatterService.iso8601FullFormatter)
        return decoder
    }
    
    func decode<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let decoder = getDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
