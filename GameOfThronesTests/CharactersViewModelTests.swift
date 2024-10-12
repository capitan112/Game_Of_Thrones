//
//  CharactersViewModelTests.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//
@testable import GameOfThrones
import PromiseKit
import XCTest

final class CharactersViewModelTests: XCTestCase {
    var viewModel: CharactersViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = CharactersViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchCharactersSuccess() {
        // Given
        let mockCharacters = [
            Character(url: "1", name: "Jon Snow", gender: "Male", culture: "Northmen", born: "In 283 AC", died: "N/A", aliases: ["Lord Snow"], father: "", mother: "", spouse: "", allegiances: [], books: [], povBooks: [], tvSeries: ["Season 1"], playedBy: ["Kit Harington"]),
            Character(url: "2", name: "Daenerys Targaryen", gender: "Female", culture: "Valyrian", born: "In 284 AC", died: "In 305 AC", aliases: ["Khaleesi"], father: "", mother: "", spouse: "", allegiances: [], books: [], povBooks: [], tvSeries: ["Season 1"], playedBy: ["Emilia Clarke"]),
        ]
        mockNetworkService.mockCharacters = mockCharacters

        // When
        let expectation = self.expectation(description: "fetchCharacters")

        viewModel.fetchCharacters().done { characters in
            // Then
            XCTAssertEqual(characters.count, 2)
            XCTAssertEqual(self.viewModel.characters.count, 2)
            XCTAssertEqual(self.viewModel.filteredCharacters.count, 2)

            XCTAssertEqual(characters[0].name, "Jon Snow")
            XCTAssertEqual(characters[0].gender, "Male")
            XCTAssertEqual(characters[0].culture, "Northmen")

            XCTAssertEqual(characters[1].name, "Daenerys Targaryen")
            XCTAssertEqual(characters[1].gender, "Female")
            XCTAssertEqual(characters[1].died, "In 305 AC")

            expectation.fulfill()
        }.catch { error in
            XCTFail("Fetch characters failed with error: \(error)")
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchCharactersFailure() {
        // Given
        mockNetworkService.shouldFail = true
        mockNetworkService.errorToReturn = .networkError(NSError(domain: "TestError", code: -1, userInfo: nil))

        // When
        let expectation = self.expectation(description: "fetchCharacters")

        viewModel.fetchCharacters().catch { error in
            // Then
            XCTAssertNotNil(error)
            XCTAssertTrue(self.viewModel.characters.isEmpty)
            XCTAssertTrue(self.viewModel.filteredCharacters.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFilteringWithEmptyTarget() {
        // Given
        let mockCharacters = [
            Character(url: "1", name: "Arya Stark", gender: "Female", culture: "Northmen", born: "In 289 AC", died: "N/A", aliases: ["No One"], father: "Eddard Stark", mother: "Catelyn Stark", spouse: "", allegiances: [], books: [], povBooks: [], tvSeries: ["Season 1"], playedBy: ["Maisie Williams"]),
        ]
        viewModel.setUp(characters: mockCharacters)

        // When
        viewModel.filtering(with: "")

        // Then
        XCTAssertEqual(viewModel.filteredCharacters.count, 1)
    }

    func testFilteringWithNonEmptyTarget() {
        // Given
        let mockCharacters = [
            Character(url: "1", name: "Arya Stark", gender: "Female", culture: "Northmen", born: "In 289 AC", died: "N/A", aliases: ["No One"], father: "Eddard Stark", mother: "Catelyn Stark", spouse: "", allegiances: [], books: [], povBooks: [], tvSeries: ["Season 1"], playedBy: ["Maisie Williams"]),
            Character(url: "2", name: "Sansa Stark", gender: "Female", culture: "Northmen", born: "In 286 AC", died: "N/A", aliases: ["Little Bird"], father: "Eddard Stark", mother: "Catelyn Stark", spouse: "", allegiances: [], books: [], povBooks: [], tvSeries: ["Season 1"], playedBy: ["Sophie Turner"]),
        ]
        viewModel.setUp(characters: mockCharacters)

        // When
        viewModel.filtering(with: "Sansa")

        // Then
        XCTAssertEqual(viewModel.filteredCharacters.count, 1)
        XCTAssertEqual(viewModel.filteredCharacters[0].name, "Sansa Stark")
    }
}
