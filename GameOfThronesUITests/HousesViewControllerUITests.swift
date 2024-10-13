//
//  HousesViewControllerUITests.swift
//  GameOfThronesUITests
//
//  Created by Oleksiy Chebotarov on 11/10/2024.
//

import XCTest

final class HousesViewControllerUITests: XCTestCase {
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

    func testHousesTableViewDisplaysHouses() {
        let housesTab = app.tabBars.buttons["Houses"]

        XCTAssertTrue(housesTab.exists, "The Houses tab should exist.")
        housesTab.tap()

        let housesTableView = app.tables["HousesTableView"]

        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: housesTableView, handler: nil)

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(housesTableView.exists, "The houses table view should exist.")
        XCTAssertGreaterThan(housesTableView.cells.count, 0, "The table view should contain at least one cell.")

        let firstCell = housesTableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts["The North"].exists, "The first house should be 'The North'.")
        XCTAssertTrue(firstCell.staticTexts["Winter is Coming"].exists, "The first house should be 'Winter is Coming'.")
    }
}
