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
        let booksTab = app.tabBars.buttons["Books"]

        XCTAssertTrue(booksTab.exists, "The Books tab should exist.")
        booksTab.tap()

        let booksTableView = app.tables["BooksTableView"]

        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: booksTableView, handler: nil)

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(booksTableView.exists, "The books table view should exist.")
        XCTAssertGreaterThan(booksTableView.cells.count, 0, "The table view should contain at least one cell.")

        let firstCell = booksTableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts["A Clash of Kings"].exists, "The first book should be 'A Clash of Kings'.")
        XCTAssertTrue(firstCell.staticTexts["768 pages"].exists, "The first book should be '768 pages'.")
    }
}
