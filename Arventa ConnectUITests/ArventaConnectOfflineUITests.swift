//
//  ArventaConnectOfflineUITests.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 10/6/20.
//

import XCTest

class ArventaConnectOfflineUITests: XCTestCase {
    
    /**
     - Description: 1.4 - Login Failed - Offline When Logging in.
     - Note: Cannot be tested on Firebase Testlab - Error occurs
     */
    func test_TC1a04_LoginWhileOffline() throws {
        // UI tests must launch the application that they test.
        let app = TestHelpers.startAndWaitForABit()
        
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
     - Description: All Verification tests with offline (to avoid getting locked)
     - TC 1.06 - Login Failed - Offline When Verifying Mobile Code
     - TC 1.08 - Resend Mobile Verification Code - Offline
     */
    func test_TC1c06a08_LoginVerificationOffline() throws {
        // UI tests must launch the application that they test.
        let app = TestHelpers.startAndWaitForABit()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "WHS Monitor",
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["WHS Monitor"].exists)
        
        LoginTestHelper.enterCredentialsAndTapLogin(username: "whsrogomi1",
                                                    password: "watsoN#12345")
        
        // Test Case 1.2 - Testing access to verification screen after valid login
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        app.textFields.firstMatch.tap()
        LoginTestHelper.enterOTPCode(code: "123123")
        
        // Test Case 1.5 - Testing error message when entering invalid code
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        TestHelpers.executeWhileOffline {
            // Test Case 1.6 - Testing error message when attempting to verify while offline
            app.buttons["CONTINUE"].tap()
            TestHelpers.expectAlert(withTitle: "Error",
                                    andAssertMessage: "You are currently offline.",
                                    thenTap: "OK",
                                    butWait: true,
                                    inTestCase: self)
            
            // Segue for Test Case 1.8 -
            // Testing error message when attempting to send the code while offline
            app.buttons["Resend code"].tap()
            TestHelpers.expectAlert(withTitle: "Error",
                                    andAssertMessage: "You are currently offline.",
                                    thenTap: "OK",
                                    butWait: true,
                                    inTestCase: self)
        }
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
    }
}
