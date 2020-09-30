//
//  Arventa_ConnectLoginUITest.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest

class Arventa_ConnectLoginUITest: XCTestCase {
    /**
     - Naming Convention
     - test_TC1a1_LoginSuccessWOVerification
     - * test - required by XCTest to annotate test
     - * _ - underscore, used to seperate parts of name
     - * TC1a1 - Test Case 1.1
     - * LoginSuccessWOVerification - shortening descriptions Login Success Without Mobile Verification
     */
    
    // MARK: Helpers
    /**
     - 1.1 - Login Success - Without Mobile Verification
     */
    func test_TC1a1_LoginSuccessWOVerification() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        LoginTestHelper.enterCredentialsAndTapLogin(username: "whs_numlock",
                                                    password: "watsoN#12345")
        
        let greetingUserLabel = app.staticTexts["greetingUserLabel"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: greetingUserLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(greetingUserLabel.label.range(of:"whs_numlock Rogomi"))
        
//        app.buttons["sideMenuButton"].tap()
//        app.staticTexts["Log out"]
//            .coordinate(withNormalizedOffset: .zero)
//            .tap()
        
//        TestHelpers.validateLoginPage()
    }
    
    /**
     - 1.2 - Login Success - Without Mobile Verification
     */
    func test_TC1a2_LoginSuccessWVerification() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "Store Manifest",
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["Store Manifest"].exists)
        
        LoginTestHelper.enterCredentialsAndTapLogin(username: "sm_numlock1",
                                                    password: "watsoN#12345")
        
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        app.textFields.firstMatch.tap()
        LoginTestHelper.enterOTPCode(code: "123123")
    }
    
    /**
     - 1.3 - Login Failed - Invalid Credentials
     */
    func test_TC1a3_LoginInvalidCredentials() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        LoginTestHelper.enterCredentialsAndTapLogin(username: "failaccount01",
                                                    password: "password123")
        
        
        TestHelpers.expectAlert(withTitle: "Error",
                                andAssertMessage: "Please enter a valid Username and Password.",
                                thenTap: "OK",
                                butWait: true,
                                inTestCase: self)
        
        LoginTestHelper.validateLoginPage(emptyFields: false)
    }
    
    /**
     - 1.4 - Login Failed - Offline When Logging in.
     - Cannot be tested on Firebase Testlab - Error occurs
     */
    func test_TC1a4_LoginWhileOffline() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }

        TestHelpers.executeWhileOffline {
            LoginTestHelper.enterCredentialsAndTapLogin(username: "failaccount01",
                                                    password: "password123")
            
            TestHelpers.expectAlert(withTitle: "Error",
                                    andAssertMessage: "You are currently offline.",
                                    thenTap: "OK",
                                    butWait: true,
                                    inTestCase: self)
        }
        
        LoginTestHelper.validateLoginPage(emptyFields: false)
    }
    
    /**
     - 1.5 - Login Failed - Wrong Mobile Verification Code
     */
    func test_TC1a5_LoginWrongCode() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "Store Manifest",
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["Store Manifest"].exists)
        LoginTestHelper.enterCredentialsAndTapLogin(username: "sm_numlock1",
                                                    password: "watsoN#12345")
        
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        app.textFields.firstMatch.tap()
        
        //This assumes that the OTP is really not 123123
        LoginTestHelper.enterOTPCode(code: "123123")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        app.buttons["CONTINUE"].tap()
        TestHelpers.expectAlert(withTitle: "Error",
                                andAssertMessage: "Invalid Security Code.",
                                thenTap: "OK",
                                butWait: true,
                                inTestCase: self)
        
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
    }
    
    /**
     - 1.6 - Login Failed - Wrong Mobile Verification Code
     - Cannot be tested on Firebase Testlab - Error occurs
     */
    func test_TC1a6_LoginCodeOffline() throws {
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "Store Manifest",
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["Store Manifest"].exists)
        LoginTestHelper.enterCredentialsAndTapLogin(username: "sm_numlock1",
                                                    password: "watsoN#12345")
        
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        TestHelpers.executeWhileOffline {
            app.textFields.firstMatch.tap()
            
            //This assumes that the OTP is really not 123123
            LoginTestHelper.enterOTPCode(code: "123123")
            app.toolbars["Toolbar"].buttons["Done"].tap()
            
            app.buttons["CONTINUE"].tap()
            TestHelpers.expectAlert(withTitle: "Error",
                                    andAssertMessage: "You are currently offline.",
                                    thenTap: "OK",
                                    butWait: true,
                                    inTestCase: self)
        }
        
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
    }
    
    /**
     - 1.7 - Resend Mobile Verification Code
     */
    func test_TC1a7_ResendCode() throws {
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "Store Manifest",
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["Store Manifest"].exists)
        LoginTestHelper.enterCredentialsAndTapLogin(username: "sm_numlock1",
                                                password: "watsoN#12345")
        
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        app.buttons["Resend code"].tap()
        TestHelpers.expectAlert(withTitle: "Success",
                                andAssertMessage: "The code has been sent.",
                                thenTap: "OK",
                                butWait: true,
                                inTestCase: self)
        
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
    }
    
    /**
     - 1.8 - Resend Mobile Verification Code - Offline
     - Cannot be tested on Firebase Testlab - Error occurs
     */
    func test_TC1a8_ResendCodeOffline() throws {
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "Store Manifest",
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["Store Manifest"].exists)
        LoginTestHelper.enterCredentialsAndTapLogin(username: "sm_numlock1",
                                                    password: "watsoN#12345")
        
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        TestHelpers.executeWhileOffline {
            app.buttons["Resend code"].tap()
            TestHelpers.expectAlert(withTitle: "Error",
                                    andAssertMessage: "You are currently offline.",
                                    thenTap: "OK",
                                    butWait: true,
                                    inTestCase: self)
        }
        
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
    }
    
    /**
     - 1.9 - Exit Mobile Verification Screen
     */
    func test_TC1a9_ExitVerification() throws {
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "Store Manifest",
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["Store Manifest"].exists)
        LoginTestHelper.enterCredentialsAndTapLogin(username: "sm_numlock1",
                                                    password: "watsoN#12345")
        
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        app.buttons["backButton"].tap()
        LoginTestHelper.validateLoginPage(emptyFields: false)
    }
    
    /**
     - 1.10 - App Dropdown
     */
    func test_TC1a10_AppDropdown() throws {
        let app = XCUIApplication()
        app.launch()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        let actionsheet = app.sheets["Which app would you like to log into?"]
        XCTAssert(actionsheet.buttons["WHS Monitor"].exists)
        XCTAssert(actionsheet.buttons["MSDS"].exists)
        XCTAssert(actionsheet.buttons["Store Manifest"].exists)
        XCTAssert(actionsheet.buttons["Pest Genie"].exists)
        XCTAssert(actionsheet.buttons["Farm Minder"].exists)
        XCTAssert(actionsheet.buttons["Chemical Caddy"].exists)
        
        actionsheet.buttons["Cancel"].tap()
        LoginTestHelper.validateLoginPage()
    }
    
    /**
     - 1.11 - Login Into The Apps - Success
     */
    func test_TC1a11_LoginToAllApps() throws {
        
    }
}
