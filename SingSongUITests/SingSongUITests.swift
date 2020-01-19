//
//  SingSongUITests.swift
//  SingSongUITests
//
//  Created by Jake Grant on 3/8/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import XCTest
import SimulatorStatusMagic

class SingSongUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false

        SDStatusBarManager.sharedInstance()?.enableOverrides()
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        SDStatusBarManager.sharedInstance()?.disableOverrides()
    }

    func testExample() {
        snapshot("0Launch")
    }

}
