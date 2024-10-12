//
//  RootViewControllerTests.swift
//  GameOfThronesTests
//
//  Created by Oleksiy Chebotarov on 12/10/2024.
//
@testable import GameOfThrones
import XCTest

final class RootViewControllerTests: XCTestCase {
    var rootViewController: RootViewController!

    override func setUp() {
        super.setUp()
        rootViewController = RootViewController()
        rootViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        rootViewController = nil
        super.tearDown()
    }

    func testShowAlertAndStopActivityIndicator() {
        // Given
        let window = UIWindow()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        rootViewController.addActivityIndicator()
        rootViewController.startActivityIndicator()

        let expectation = self.expectation(description: "Activity indicator starts animating")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.rootViewController.activityIndicator, "Activity indicator should not be nil.")
            XCTAssertTrue(self.rootViewController.activityIndicator?.isAnimating ?? false, "Activity indicator should be animating.")

            self.rootViewController.showAlertAndStopActivityIndicator()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Delay to ensure alert is presented
                XCTAssertNotNil(self.rootViewController.presentedViewController, "Alert controller should be presented.")
                XCTAssertTrue(self.rootViewController.presentedViewController is UIAlertController, "Presented view controller should be UIAlertController.")

                let alertController = self.rootViewController.presentedViewController as? UIAlertController
                XCTAssertEqual(alertController?.title, "Error")
                XCTAssertEqual(alertController?.message, "Something goes wrong")
                XCTAssertEqual(alertController?.actions.first?.title, "Cancel")

                XCTAssertFalse(self.rootViewController.activityIndicator?.isAnimating ?? true, "Activity indicator should have stopped animating.")

                expectation.fulfill() // Fulfill the expectation after all checks
            }
        }

        wait(for: [expectation], timeout: 2.0) // Wait for the activity indicator and alert presentation
    }

    func testSetupConstraintsForTableView() {
        // Given
        let tableView = rootViewController.tableView

        // When
        rootViewController.setupConstraintsForTableView()

        // Then
        XCTAssertTrue(tableView.translatesAutoresizingMaskIntoConstraints == false, "TableView should have translatesAutoresizingMaskIntoConstraints set to false.")
        XCTAssertTrue(rootViewController.view.subviews.contains(tableView), "TableView should be added as a subview to the view.")

        let constraints = rootViewController.view.constraints
        let topConstraint = constraints.first { $0.firstAnchor == tableView.topAnchor }
        let leadingConstraint = constraints.first { $0.firstAnchor == tableView.leadingAnchor }
        let trailingConstraint = constraints.first { $0.firstAnchor == tableView.trailingAnchor }
        let bottomConstraint = constraints.first { $0.firstAnchor == tableView.bottomAnchor }

        XCTAssertNotNil(topConstraint, "Top anchor constraint should be activated.")
        XCTAssertNotNil(leadingConstraint, "Leading anchor constraint should be activated.")
        XCTAssertNotNil(trailingConstraint, "Trailing anchor constraint should be activated.")
        XCTAssertNotNil(bottomConstraint, "Bottom anchor constraint should be activated.")
    }
}
