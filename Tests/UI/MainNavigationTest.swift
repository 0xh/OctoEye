//
//  MainNavigationTest.swift
//  UITest
//
//  Created by mzp on 2017/07/31.
//  Copyright © 2017 mzp. All rights reserved.
//

import XCTest

internal class MainNavigationTest: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["setAccessToken"]
        app.launch()
    }

    func testMainNavigation() {
        let app = XCUIApplication()

        // it has navigationbar and tabBar
        XCTAssert(app.navigationBars.element.exists)
        XCTAssert(app.tabBars.element.exists)

        // Repositories tab is selected
        XCTAssert(app.navigationBars["Repositories"].exists)

        // Switch to Preferences
        app.tabBars.buttons["Preferences"].tap()
        XCTAssert(app.navigationBars["Preferences"].exists)

        // Switch to Repositories
        app.tabBars.buttons["Repositories"].tap()
        XCTAssert(app.navigationBars["Repositories"].exists)
    }
}
