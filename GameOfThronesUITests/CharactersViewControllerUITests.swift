//
//  CharactersViewControllerUITests.swift
//  GameOfThronesUITests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import XCTest
import PromiseKit

final class CharactersViewControllerUITests: XCTestCase {

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

    func testCharactersTabDisplaysCharacters() {
           // Given: Accessing the tab bar controller
           let charactersTab = app.tabBars.buttons["Characters"]

           // When: Selecting the Characters tab
           XCTAssertTrue(charactersTab.exists, "The Characters tab should exist.")
           charactersTab.tap()

           // Then: Check if the Characters table view appears
           let charactersTableView = app.tables["CharactersTableView"]

           let exists = NSPredicate(format: "exists == true")
           expectation(for: exists, evaluatedWith: charactersTableView, handler: nil)
           waitForExpectations(timeout: 10, handler: nil)

           XCTAssertTrue(charactersTableView.exists, "The characters table view should exist.")

           // Verify that the number of cells is greater than 0
           XCTAssertGreaterThan(charactersTableView.cells.count, 0, "The table view should contain at least one cell.")

           // Check the title of the first character (adjust the character name as needed)
           let firstCell = charactersTableView.cells.element(boundBy: 0)
           XCTAssertTrue(firstCell.staticTexts["Culture: Braavosi"].exists, "The first character cell should display 'Jon Snow'.")
       }
}
