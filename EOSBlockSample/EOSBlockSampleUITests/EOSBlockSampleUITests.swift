//
//  EOSBlockSampleUITests.swift
//  EOSBlockSampleUITests
//
//  Created by Mark Johnson on 8/6/19.
//  Copyright © 2019 Mark Johnson. All rights reserved.
//

import XCTest

class EOSBlockSampleUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Tests loading blocks, tapping the first block in the table and if the detail view is loaded.
    func testOpeningFirstBlockInDetailView() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.navigationBars["EOSBlockSample.BlockListView"].buttons["Refresh"].tap()
        XCTAssert(app.tables["blockTable"]/*@START_MENU_TOKEN@*/.staticTexts["row0"]/*[[".cells",".staticTexts[\"Block 72959259\"]",".staticTexts[\"row0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 10))
        app.tables["blockTable"]/*@START_MENU_TOKEN@*/.staticTexts["row0"]/*[[".cells",".staticTexts[\"Block 72959259\"]",".staticTexts[\"row0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.staticTexts["producerLabel"].waitForExistence(timeout: 10))
    }
}
