//
//  CharactersViewControllerUITests.swift
//  GameOfThronesUITests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import XCTest

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
        let charactersTab = app.tabBars.buttons["Characters"]

        XCTAssertTrue(charactersTab.exists, "The Characters tab should exist.")
        charactersTab.tap()

        let charactersTableView = app.tables["CharactersTableView"]

        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: charactersTableView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(charactersTableView.exists, "The characters table view should exist.")
        XCTAssertGreaterThan(charactersTableView.cells.count, 0, "The table view should contain at least one cell.")

        let firstCell = charactersTableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts["Culture: Northmen"].exists, "The first character cell should display 'Culture: Northmen'.")
        XCTAssertTrue(firstCell.staticTexts["Born: In 263 AC"].exists, "The first character cell should display 'Born: In 263 AC'.")
    }
}
