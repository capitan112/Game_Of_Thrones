//
//  MockNetworkService.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 12/10/2024.
//

import Foundation
import PromiseKit

class MockNetworkService: NetworkServiceProtocol {
    private var decoderService: JSONDecoderServiceProtocol

    required init(decoderService: JSONDecoderServiceProtocol = JSONDecoderService()) {
        self.decoderService = decoderService
    }

    func fetchBooks() throws -> Promise<[Book]> {
        let mockBooks = [
            Book(
                url: "https://anapioficeandfire.com/api/books/2",
                name: "A Clash of Kings",
                isbn: "978-0553108033",
                authors: ["George R. R. Martin"],
                numberOfPages: 768,
                publisher: "Bantam Books",
                country: "United States",
                mediaType: "Hardcover",
                released: Date(),
                characters: []
            ),
            Book(
                url: "https://anapioficeandfire.com/api/books/1",
                name: "A Game of Thrones",
                isbn: "978-0553103540",
                authors: ["George R. R. Martin"],
                numberOfPages: 694,
                publisher: "Bantam Books",
                country: "United States",
                mediaType: "Hardcover",
                released: Date(),
                characters: []
            ),
        ]
        return Promise.value(mockBooks) // Return mock data
    }

    func fetchHouses() throws -> Promise<[House]> {
        let mockHouses = [
            House(
                name: "Stark",
                region: "The North",
                words: "Winter is Coming"
            ),
            House(
                name: "Lannister",
                region: "The Westerlands",
                words: "Hear Me Roar!"
            ),
        ]
        return Promise.value(mockHouses) // Return mock house data
    }

    func fetchCharacters() throws -> Promise<[Character]> {
        let mockCharacters = [
            Character(
                url: "https://anapioficeandfire.com/api/characters/1",
                name: "Eddard Stark",
                gender: "Male",
                culture: "Northmen",
                born: "In 263 AC",
                died: "In 298 AC",
                aliases: ["Ned Stark"],
                father: "Rickard Stark",
                mother: "Lysa Stark",
                spouse: "Catelyn Stark",
                allegiances: ["House Stark"],
                books: ["A Game of Thrones", "A Clash of Kings"],
                povBooks: ["A Game of Thrones"],
                tvSeries: ["Game of Thrones"],
                playedBy: ["Sean Bean"]
            ),
            Character(
                url: "https://anapioficeandfire.com/api/characters/2",
                name: "Catelyn Stark",
                gender: "Female",
                culture: "Northmen",
                born: "In 264 AC",
                died: "In 298 AC",
                aliases: ["Catelyn Tully"],
                father: "Hoster Tully",
                mother: "Lysa Tully",
                spouse: "Eddard Stark",
                allegiances: ["House Stark"],
                books: ["A Game of Thrones", "A Clash of Kings"],
                povBooks: ["A Clash of Kings"],
                tvSeries: ["Game of Thrones"],
                playedBy: ["Michelle Fairley"]
            ),
        ]
        return Promise.value(mockCharacters) // Return mock character data
    }
}
