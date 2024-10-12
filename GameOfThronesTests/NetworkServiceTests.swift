//
//  NetworkServiceTests.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

@testable import GameOfThrones
import PromiseKit
import XCTest

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockDecoderService: MockJSONDecoderService!

    override func setUp() {
        super.setUp()
        mockDecoderService = MockJSONDecoderService()
        networkService = NetworkService(decoderService: mockDecoderService)
    }

    override func tearDown() {
        networkService = nil
        mockDecoderService = nil
        super.tearDown()
    }

    func testFetchHousesSuccess() {
        // Given
        let mockHouses: [House] = [
            House(name: "House Stark", region: "The North", words: "Winter is Coming"),
        ]
        mockDecoderService.mockData = try? JSONEncoder().encode(mockHouses)

        // When
        let expectation = XCTestExpectation(description: "Fetch Houses")
        firstly {
            try networkService.fetchHouses()
        }.done { houses in
            // Then
            XCTAssertEqual(houses.count, 1)
            XCTAssertEqual(houses.first?.name, "House Stark")
            XCTAssertEqual(houses.first?.region, "The North")
            XCTAssertEqual(houses.first?.words, "Winter is Coming")
            expectation.fulfill()
        }.catch { error in
            XCTFail("Expected successful fetch, but got error: \(error)")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchHousesBadUrl() {
        // Given
        let mockNetworkService = MockNetworkService(decoderService: mockDecoderService)
        mockNetworkService.shouldFail = true
        mockNetworkService.errorToReturn = .badUrl

        let expectation = XCTestExpectation(description: "Fetch Houses with Bad URL")

        // When
        do {
            try mockNetworkService.fetchHouses().catch { error in
                // Then
                XCTAssertEqual(error as? NetworkError, .badUrl)
                expectation.fulfill()
            }
        } catch {
            XCTFail("The function threw an error: \(error)")
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchHousesDecodingError() {
        // Given
        let invalidJSONData = "{ invalid json }".data(using: .utf8)!
        mockDecoderService.mockData = invalidJSONData

        // When
        let expectation = XCTestExpectation(description: "Fetch Houses with Decoding Error")

        firstly {
            try networkService.fetchHouses()
        }.done { _ in
            XCTFail("Expected decoding error, but got success.")
            expectation.fulfill()
        }.catch { error in
            // Then
            if case NetworkError.decodingError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected NetworkError.decodingError, but got \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchBooksSuccess() {
        // Given
        let mockBooks: [Book] = [
            Book(
                url: "someurl",
                name: "A Game of Thrones",
                isbn: "978-0553103540",
                authors: ["George R. R. Martin"],
                numberOfPages: 694,
                publisher: "Bantam Books",
                country: "United States",
                mediaType: "Print",
                released: Date(),
                characters: ["url1", "url2"]
            ),
        ]
        mockDecoderService.mockData = try? JSONEncoder().encode(mockBooks)

        // When
        let expectation = XCTestExpectation(description: "Fetch Books")
        firstly {
            try networkService.fetchBooks()
        }.done { books in
            // Then
            XCTAssertEqual(books.count, 1)
            XCTAssertEqual(books.first?.name, "A Game of Thrones")
            XCTAssertEqual(books.first?.isbn, "978-0553103540")
            XCTAssertEqual(books.first?.authors.first, "George R. R. Martin")
            XCTAssertEqual(books.first?.numberOfPages, 694)
            XCTAssertEqual(books.first?.publisher, "Bantam Books")
            XCTAssertEqual(books.first?.country, "United States")
            XCTAssertEqual(books.first?.mediaType, "Print")
            XCTAssertNotNil(books.first?.released) // Check that the date is not nil
            XCTAssertEqual(books.first?.characters.count, 2)
            expectation.fulfill()
        }.catch { error in
            XCTFail("Expected successful fetch, but got error: \(error)")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchBooksBadUrl() {
        // Given
        let mockNetworkService = MockNetworkService(decoderService: mockDecoderService)
        mockNetworkService.shouldFail = true
        mockNetworkService.errorToReturn = .badUrl

        let expectation = XCTestExpectation(description: "Fetch Books with Bad URL")

        // When
        do {
            try mockNetworkService.fetchBooks().catch { error in
                // Then
                XCTAssertEqual(error as? NetworkError, .badUrl)
                expectation.fulfill()
            }
        } catch {
            XCTFail("The function threw an error: \(error)")
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchBooksDecodingError() {
        // Given
        let invalidJSONData = "{ invalid json }".data(using: .utf8)!
        mockDecoderService.mockData = invalidJSONData

        // When
        let expectation = XCTestExpectation(description: "Fetch Houses with Decoding Error")

        firstly {
            try networkService.fetchBooks()
        }.done { _ in
            XCTFail("Expected decoding error, but got success.")
            expectation.fulfill()
        }.catch { error in
            // Then
            if case NetworkError.decodingError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected NetworkError.decodingError, but got \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchCharactersSuccess() {
        // Given
        let mockCharacters: [Character] = [
            Character(
                url: "someurl",
                name: "Jon Snow",
                gender: "Male",
                culture: "Northmen",
                born: "In the North",
                died: "",
                aliases: ["Lord Snow"],
                father: "Eddard Stark",
                mother: "Unknown",
                spouse: "None",
                allegiances: ["House Stark"],
                books: ["A Game of Thrones"],
                povBooks: ["A Game of Thrones"],
                tvSeries: ["Game of Thrones"],
                playedBy: ["Kit Harington"]
            ),
        ]
        mockDecoderService.mockData = try? JSONEncoder().encode(mockCharacters)

        // When
        let expectation = XCTestExpectation(description: "Fetch Characters")
        firstly {
            try networkService.fetchCharacters()
        }.done { characters in
            // Then
            XCTAssertEqual(characters.count, 1)
            XCTAssertEqual(characters.first?.name, "Jon Snow")
            XCTAssertEqual(characters.first?.gender, "Male")
            XCTAssertEqual(characters.first?.culture, "Northmen")
            expectation.fulfill()
        }.catch { error in
            XCTFail("Expected successful fetch, but got error: \(error)")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
