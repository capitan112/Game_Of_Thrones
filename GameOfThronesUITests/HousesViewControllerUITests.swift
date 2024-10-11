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
        // Given: Accessing the tab bar controller and selecting the Houses tab
        let housesTab = app.tabBars.buttons["Houses"]

        // Check if the Houses tab exists
        XCTAssertTrue(housesTab.exists, "The Houses tab should exist.")
        housesTab.tap() // Tap on the Houses tab to navigate to the HousesViewController

        // Access the Houses table view
        let housesTableView = app.tables["HousesTableView"]

        // When: Verify that the table view exists
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: housesTableView, handler: nil)

        // Increase the timeout to 5 seconds
        waitForExpectations(timeout: 5, handler: nil)

        // Then: Assertions to check the Houses table view
        XCTAssertTrue(housesTableView.exists, "The houses table view should exist.")
        
        // Verify that the number of cells is greater than 0
        XCTAssertGreaterThan(housesTableView.cells.count, 0, "The table view should contain at least one cell.")
        
        // Check the title of the first house (assuming mock data is loaded)
        let firstCell = housesTableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts["House Algood"].exists, "The first house should be 'House Algood'.")
    }
}
