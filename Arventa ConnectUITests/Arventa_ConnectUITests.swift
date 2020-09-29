//
//  Arventa_ConnectUITests.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/22/20.
//

import XCTest

class Arventa_ConnectUITests: XCTestCase {

    func testLoginVerification() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(app.staticTexts["A R V E N T A"].exists)
        XCTAssert(app.staticTexts["RISK & COMPLIANCE"].exists)
        XCTAssert(app.textFields["Username"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.buttons["Forgot Password?"].exists)
        XCTAssert(app.buttons["LOG IN"].exists)
        
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("testaccount01")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("password123")
        
        app.keyboards.buttons["done"].tap()
        app.buttons["LOG IN"].tap()
        
        XCTAssert(app.staticTexts["Verify your account"].exists)
    }
    
    func testLoginDashboard() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(app.staticTexts["A R V E N T A"].exists)
        XCTAssert(app.staticTexts["RISK & COMPLIANCE"].exists)
        XCTAssert(app.textFields["Username"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.buttons["Forgot Password?"].exists)
        XCTAssert(app.buttons["LOG IN"].exists)
        
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("testaccount02")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("password123")
        
        app.keyboards.buttons["done"].tap()
        app.buttons["LOG IN"].tap()
        
        XCTAssert(app.staticTexts["John Doe"].exists)
    }
}
