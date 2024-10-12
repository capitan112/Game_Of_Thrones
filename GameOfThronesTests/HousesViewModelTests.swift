//
//  HousesViewModelTests.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

@testable import GameOfThrones
import PromiseKit
import XCTest

final class HousesViewModelTests: XCTestCase {
    var viewModel: HousesViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = HousesViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchHousesSuccess() {
        // Given
        mockNetworkService.mockHouses = [
            House(name: "Stark", region: "The North", words: "Winter is Coming"),
            House(name: "Lannister", region: "The Westerlands", words: "Hear Me Roar"),
        ]

        // When
        let expectation = self.expectation(description: "fetchHouses")

        viewModel.fetchHouses().done { houses in
            // Then
            XCTAssertEqual(houses.count, 2)
            XCTAssertEqual(self.viewModel.houses.count, 2)
            XCTAssertEqual(self.viewModel.filteredHouses.count, 2)

            XCTAssertEqual(houses[0].name, "Stark")
            XCTAssertEqual(houses[0].region, "The North")
            XCTAssertEqual(houses[0].words, "Winter is Coming")

            XCTAssertEqual(houses[1].name, "Lannister")
            XCTAssertEqual(houses[1].region, "The Westerlands")
            XCTAssertEqual(houses[1].words, "Hear Me Roar")

            expectation.fulfill()
        }.catch { error in
            XCTFail("Fetch houses failed with error: \(error)")
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchHousesFailure() {
        // Given
        mockNetworkService.shouldFail = true
        mockNetworkService.errorToReturn = .networkError(NSError(domain: "TestError", code: -1, userInfo: nil))

        // When
        let expectation = self.expectation(description: "fetchHouses")

        viewModel.fetchHouses().catch { error in
            // Then
            XCTAssertNotNil(error)
            XCTAssertTrue(self.viewModel.houses.isEmpty)
            XCTAssertTrue(self.viewModel.filteredHouses.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFilteringWithValidInput() {
        // Given
        let mockHouses: [House] = [
            House(name: "House Stark", region: "The North", words: "Winter is Coming"),
            House(name: "House Lannister", region: "The Westerlands", words: "Hear Me Roar"),
            House(name: "House Targaryen", region: "Essos", words: "Fire and Blood"),
        ]
        viewModel.setUp(houses: mockHouses)

        // When
        viewModel.filtering(with: "Stark")

        // Then
        XCTAssertEqual(viewModel.filteredHouses.count, 1)
        XCTAssertEqual(viewModel.filteredHouses.first?.name, "House Stark")
    }

    func testFilteringWithEmptyString() {
        // Given
        let mockHouses: [House] = [
            House(name: "House Stark", region: "The North", words: "Winter is Coming"),
            House(name: "House Lannister", region: "The Westerlands", words: "Hear Me Roar"),
            House(name: "House Targaryen", region: "Essos", words: "Fire and Blood"),
        ]
        viewModel.setUp(houses: mockHouses)

        // When
        viewModel.filtering(with: "Stark")
        viewModel.filtering(with: "") // This should call discardSearching()

        // Then
        XCTAssertEqual(viewModel.filteredHouses.count, mockHouses.count)
        XCTAssertEqual(viewModel.filteredHouses.map { $0.name }, mockHouses.map { $0.name })
    }

    func testFilteringWithNoMatch() {
        // Given
        let mockHouses: [House] = [
            House(name: "House Stark", region: "The North", words: "Winter is Coming"),
            House(name: "House Lannister", region: "The Westerlands", words: "Hear Me Roar"),
            House(name: "House Targaryen", region: "Essos", words: "Fire and Blood"),
        ]
        viewModel.setUp(houses: mockHouses)

        // When
        viewModel.filtering(with: "Arryn") // No house with this name

        // Then
        XCTAssertEqual(viewModel.filteredHouses.count, 0)
    }

    func testDiscardSearching() {
        // Given
        let mockHouses: [House] = [
            House(name: "House Stark", region: "The North", words: "Winter is Coming"),
            House(name: "House Lannister", region: "The Westerlands", words: "Hear Me Roar"),
            House(name: "House Targaryen", region: "Essos", words: "Fire and Blood"),
        ]
        viewModel.setUp(houses: mockHouses)

        viewModel.filtering(with: "Lannister")

        // When
        viewModel.discardSearching()

        // Then
        XCTAssertEqual(viewModel.filteredHouses.count, mockHouses.count)
        XCTAssertEqual(viewModel.filteredHouses.map { $0.name }, mockHouses.map { $0.name })
    }
}
