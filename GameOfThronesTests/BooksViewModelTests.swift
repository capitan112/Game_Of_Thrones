//
//  BooksViewModelTests.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

@testable import GameOfThrones
import PromiseKit
import XCTest

final class BooksViewModelTests: XCTestCase {
    var viewModel: BooksViewModel!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = BooksViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchBooksSuccess() {
        // Given
        let mockBooks = [
            Book(url: "1", name: "A Game of Thrones", isbn: "9780553103540", authors: ["George R. R. Martin"], numberOfPages: 694, publisher: "Bantam Books", country: "United States", mediaType: "Hardcover", released: Date(), characters: []),
            Book(url: "2", name: "A Clash of Kings", isbn: "9780553108033", authors: ["George R. R. Martin"], numberOfPages: 768, publisher: "Bantam Books", country: "United States", mediaType: "Hardcover", released: Date(), characters: []),
        ]
        mockNetworkService.mockBooks = mockBooks

        // When
        let expectation = self.expectation(description: "fetchBooks")

        viewModel.fetchBooks().done { books in
            // Then
            XCTAssertEqual(books.count, 2)
            XCTAssertEqual(self.viewModel.books.count, 2)

            XCTAssertEqual(books[0].name, "A Game of Thrones")
            XCTAssertEqual(books[0].isbn, "9780553103540")
            XCTAssertEqual(books[0].authors, ["George R. R. Martin"])

            XCTAssertEqual(books[1].name, "A Clash of Kings")
            XCTAssertEqual(books[1].isbn, "9780553108033")
            XCTAssertEqual(books[1].numberOfPages, 768)

            expectation.fulfill()
        }.catch { error in
            XCTFail("Fetch books failed with error: \(error)")
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testFetchBooksFailure() {
        // Given
        mockNetworkService.shouldFail = true
        mockNetworkService.errorToReturn = .networkError(NSError(domain: "TestError", code: -1, userInfo: nil))

        // When
        let expectation = self.expectation(description: "fetchBooks")

        viewModel.fetchBooks().done { _ in
            XCTFail("Expected fetchBooks to fail, but it succeeded.")
        }.catch { error in
            // Then
            XCTAssertNotNil(error, "Expected an error, but got nil.")
            XCTAssertTrue(self.viewModel.books.isEmpty, "Expected books array to be empty on failure.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testSetUpBooks() {
        // Given
        let mockBooks = [
            Book(url: "1", name: "A Game of Thrones", isbn: "9780553103540", authors: ["George R. R. Martin"], numberOfPages: 694, publisher: "Bantam Books", country: "United States", mediaType: "Hardcover", released: Date(), characters: []),
            Book(url: "2", name: "A Clash of Kings", isbn: "9780553108033", authors: ["George R. R. Martin"], numberOfPages: 768, publisher: "Bantam Books", country: "United States", mediaType: "Hardcover", released: Date(), characters: []),
        ]

        // When
        viewModel.setUp(books: mockBooks)

        // Then
        XCTAssertEqual(viewModel.books.count, 2)
        XCTAssertEqual(viewModel.books[0].name, "A Game of Thrones")
        XCTAssertEqual(viewModel.books[1].name, "A Clash of Kings")
    }
}
