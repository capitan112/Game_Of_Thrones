//
//  BooksViewControllerUITests.swift
//  GameOfThronesUITests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//
import Foundation
import XCTest

final class BooksViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    func testBooksTableViewDisplaysBooks() {
        // Given: Accessing the tab bar controller and selecting the Books tab
        let booksTab = app.tabBars.buttons["Books"]

        // Check if the Books tab exists
        XCTAssertTrue(booksTab.exists, "The Books tab should exist.")
        booksTab.tap() // Tap on the Books tab to navigate to the BooksViewController

        // Access the Books table view
        let booksTableView = app.tables["BooksTableView"]

        // When: Verify that the table view exists
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: booksTableView, handler: nil)

        // Increase the timeout to 5 seconds
        waitForExpectations(timeout: 5, handler: nil)

        // Then: Assertions to check the Books table view
        XCTAssertTrue(booksTableView.exists, "The books table view should exist.")
        
        // Verify that the number of cells is greater than 0
        XCTAssertGreaterThan(booksTableView.cells.count, 0, "The table view should contain at least one cell.")
        
        // Check the title of the first book (assuming mock data is loaded)
        let firstCell = booksTableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts["A Game of Thrones"].exists, "The first book should be 'A Game of Thrones'.")
    }
}
