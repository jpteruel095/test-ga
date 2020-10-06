//
//  ArventaConnectLocalUITests.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 10/6/20.
//

import XCTest

class ArventaConnectLocalUITests: XCTestCase {    
    /**
     - Description: All Verification tests (to avoid getting locked)
     - TC 1.02 - Login Success - Without Mobile Verification
     - TC 1.05 - Login Failed - Wrong Mobile Verification Code
     - TC 1.07 - Resend Mobile Verification Code
     - TC 1.09 - Exit Mobile Verification Screen
     */
    func test_TC1c02a05a07a09_LoginVerification() throws {
        // UI tests must launch the application that they test.
        let app = TestHelpers.startAndWaitForABit()
        
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
        
        // Test Case 1.2 - Testing access to verification screen after valid login
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        TestHelpers.takeScreenshot(inTestCase: self)
        
        app.textFields.firstMatch.tap()
        LoginTestHelper.enterOTPCode(code: "123123")
        TestHelpers.takeScreenshot(inTestCase: self)
        
        // Test Case 1.5 - Testing error message when entering invalid code
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.buttons["CONTINUE"].tap()
        TestHelpers.expectAlert(withTitle: "Error",
                                andAssertMessage: "Invalid Security Code.",
                                thenTap: "OK",
                                butWait: true,
                                shouldTakeScreenshot: true,
                                inTestCase: self)
        
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        // Test Case 1.7 - Testing alert message when attempting to send the code
        app.buttons["Resend code"].tap()
        TestHelpers.expectAlert(withTitle: "Success",
                                andAssertMessage: "The code has been sent.",
                                thenTap: "OK",
                                butWait: true,
                                shouldTakeScreenshot: true,
                                inTestCase: self)
        
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        
        // Test Case 1.9 - Testing action when tapping back button
        app.buttons["backButton"].tap()
        LoginTestHelper.validateLoginPage(emptyFields: false)
    }

}
