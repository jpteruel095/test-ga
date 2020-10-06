//
//  Arventa_ConnectLoginUITest.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest

class Arventa_ConnectTC1LoginUITest: XCTestCase {
    /**
     - Naming Convention
     - test_TC1a1_LoginSuccessWOVerification
     - * test - required by XCTest to annotate test
     - * _ - underscore, used to seperate parts of name
     - * TC1a1 - Test Case 1.1
     - * LoginSuccessWOVerification - shortening descriptions Login Success Without Mobile Verification
     */
    
    /**
     - Description: 1.1 - Login Success - Without Mobile Verification
     */
    func test_TC1a01_LoginSuccessWOVerification() throws {
        // UI tests must launch the application that they test.
        let app = TestHelpers.startAndWaitForABit()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        TestHelpers.takeScreenshot(inTestCase: self)
        LoginTestHelper.enterCredentialsAndTapLogin(username: "whs_numlock",
                                                    password: "watsoN#12345")
        XCTAssert(app.activityIndicators["In progress"].exists)
        
        let greetingUserLabel = app.staticTexts["greetingUserLabel"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: greetingUserLabel, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        
        XCTAssertNotNil(greetingUserLabel.label.range(of:"whs_numlock Rogomi"))
        TestHelpers.takeScreenshot(inTestCase: self)
    }
    
    /**
     - Description: 1.2 - Login Success - Without Mobile Verification
     - Important: Be careful of running this as it could lock the user out after certain number of attempts.     
     */
    func NA_test_TC1a02_LoginSuccessWVerification() throws {
        // UI tests must launch the application that they test.
        let app = TestHelpers.startAndWaitForABit()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        // Initially, the default selected app is always WHS Monitor
        TestHelpers.tapOverStaticText("WHS Monitor")
        TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                      andTap: "Store Manifest",
                                      shouldTakeScreenshot: true,
                                      inTestCase: self)
        
        XCTAssert(app.staticTexts["Store Manifest"].exists)
        TestHelpers.takeScreenshot(inTestCase: self)
        
        LoginTestHelper.enterCredentialsAndTapLogin(username: "sm_numlock1",
                                                    password: "watsoN#12345")
        
        let verifyLabel = app.staticTexts["Verify your account"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: verifyLabel, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssert(app.staticTexts["Code is sent to ********2544"].exists)
        TestHelpers.takeScreenshot(inTestCase: self)
        
        app.textFields.firstMatch.tap()
        LoginTestHelper.enterOTPCode(code: "123123")
    }
    
    /**
     - Description: 1.3 - Login Failed - Invalid Credentials
     - Important: Be careful of running this as it could lock the user out after certain number of attempts.
     */
    func test_TC1a03_LoginInvalidCredentials() throws {
        // UI tests must launch the application that they test.
        let app = TestHelpers.startAndWaitForABit()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        LoginTestHelper.enterCredentialsAndTapLogin(username: "failaccount01",
                                                    password: "password123")
        
        
        TestHelpers.expectAlert(withTitle: "Error",
                                andAssertMessage: "Please enter a valid Username and Password.",
                                thenTap: "OK",
                                butWait: true,
                                shouldTakeScreenshot: true,
                                inTestCase: self)
        
        LoginTestHelper.validateLoginPage(emptyFields: false)
    }
    
    /**
     - Description: 1.10 - App Dropdown
     */
    func test_TC1a10_AppDropdown() throws {
        let app = TestHelpers.startAndWaitForABit()
        
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
        TestHelpers.takeScreenshot(inTestCase: self)
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            actionsheet.buttons["Cancel"].tap()
        }
        LoginTestHelper.validateLoginPage()
    }
    
    /**
     - Description: 1.11 - Login Into The Apps - Success
     */
    func test_TC1a11_LoginToAllApps() throws {
        let app = TestHelpers.startAndWaitForABit()
        
        if !LoginTestHelper.didForceLogout(){
            LoginTestHelper.validateLoginPage()
        }
        
        TestAccount.allCases.forEach { (account) in
            //WHS Monitor is always the default selected app
            TestHelpers.tapOverStaticText("WHS Monitor")
            TestHelpers.expectActionSheet(title: "Which app would you like to log into?",
                                          andTap: account.appName,
                                          inTestCase: self)
            
            XCTAssert(app.staticTexts[account.appName].exists)
            
            LoginTestHelper.enterCredentialsAndTapLogin(username: account.getUsername(),
                                                        password: account.getPassword())
            
            let greetingUserLabel = app.staticTexts["greetingUserLabel"]
            let exists = NSPredicate(format: "exists == 1")
            expectation(for: exists, evaluatedWith: greetingUserLabel, handler: nil)
            waitForExpectations(timeout: 20, handler: nil)
            
            XCTAssertNotNil(greetingUserLabel.label.range(of: account.getName()))
            TestHelpers.takeScreenshot(inTestCase: self)
            
            if UIDevice.is_iPhone(){
                app.buttons["sideMenuButton"].tap()
            }
            app.staticTexts["Log out"]
                .coordinate(withNormalizedOffset: .zero)
                .tap()
            
            LoginTestHelper.validateLoginPage()
        }
    }
}
