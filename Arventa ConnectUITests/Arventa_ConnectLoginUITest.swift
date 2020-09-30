//
//  Arventa_ConnectLoginUITest.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest

class Arventa_ConnectLoginUITest: XCTestCase {
    
    // MARK: Helpers
    /**
     - 1.1 - Login Success - Without Mobile Verification
     */
    func testLoginSuccessWOVerification() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("whs_numlock")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("watsoN#12345")
        
        app.keyboards.buttons["done"].tap()
        app.buttons["LOG IN"].tap()
        
        let greetingUserLabel = app.staticTexts["greetingUserLabel"]
        
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: greetingUserLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(greetingUserLabel.label.range(of:"whs_numlock Rogomi"))
        
        app.buttons["sideMenuButton"].tap()
        app.staticTexts["Logout"].tap()
        
        TestHelpers.validateLoginPage(app: app)
    }
    
    /**
     - 1.2 - Login Success - Without Mobile Verification
     */
    func testLoginSuccessWVerification() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        TestHelpers.validateLoginPage(app: app)
        
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("testaccount02")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("password123")
        
        app.keyboards.buttons["done"].tap()
        app.buttons["LOG IN"].tap()
        
        XCTAssert(app.staticTexts["Verify your account"].exists)
    }
    
    /**
     - 1.3 - Login Failed - Invalid Credentials
     */
    func testLoginInvalidCredentials() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("failaccount01")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("password123")
        
        app.keyboards.buttons["done"].tap()
        app.buttons["LOG IN"].tap()
        
        // wait
        let alert = app.alerts["Error"]
        
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: alert, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssert(alert.staticTexts["The credentials you entered are not valid."].exists)
        alert.buttons["OK"].tap()
        TestHelpers.validateLoginPage(app: app, emptyFields: false)
        
        Springboard.deleteMyApp()
    }
    
    /**
     - 1.4 - Login Failed - Offline When Logging in.
     - Cannot be tested on Firebase Testlab - Error occurs
     */
//    func testLoginWhileOffline() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
//        settingsApp.launch()
//        settingsApp.tables.cells["Airplane Mode"].tap()
//
//        // Relaunch app without restarting it
//        app.activate()
//
//        app.textFields["Username"].tap()
//        app.textFields["Username"].typeText("failaccount01")
//
//        app.secureTextFields["Password"].tap()
//        app.secureTextFields["Password"].typeText("password123")
//
//        app.keyboards.buttons["done"].tap()
//        app.buttons["LOG IN"].tap()
//
//        // wait
//        let alert = app.alerts["Error"]
//
//        let exists = NSPredicate(format: "exists == 1")
//        expectation(for: exists, evaluatedWith: alert, handler: nil)
//        waitForExpectations(timeout: 5, handler: nil)
//
//        XCTAssert(alert.staticTexts["You are currently offline."].exists)
//        alert.buttons["OK"].tap()
//
//        settingsApp.launch()
//        settingsApp.tables.cells["Airplane Mode"].tap()
//
//        // Relaunch app without restarting it
//        app.activate()
//        self.validateLoginPage(app: app, emptyFields: false)
//    }
}
