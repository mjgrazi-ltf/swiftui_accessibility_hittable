//
//  TestProjectUITests.swift
//  TestProjectUITests
//
//  Created by Mike Graziano on 12/7/21.
//

import XCTest

class TestProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        try tap(identifier: "modalbutton")
        try tap(identifier: "dogbutton")
        try tap(identifier: "ferretbutton")
        try tap(identifier: "parrotbutton")
        try tap(identifier: "horsebutton")
        try tap(identifier: "cancelbutton")
        try tap(identifier: "Dog_dismiss")
        try tap(identifier: "Ferret_dismiss")
    }

    func tap(identifier: String) throws {
        let elementQuery = XCUIApplication()
            .descendants(matching: XCUIElement.ElementType.any)
            .matching(identifier: identifier)
        elementQuery.firstMatch.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
