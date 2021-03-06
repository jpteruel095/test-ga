//
//  Arventa_ConnectDashboardUITest.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest

class Arventa_ConnectTC2DashboardUITest: XCTestCase {
    /**
     - Description: 2.1 - Access Dashboard Screen
     */
    func test_TC2a01_AccessDashboardScreen() throws {
        let app = TestHelpers.startAndWaitForABit()
        
        if !LoginTestHelper.didLoginIfNot(inTestCase: self){
            let greetingUserLabel = app.staticTexts["greetingUserLabel"]
            XCTAssertNotNil(greetingUserLabel.label.range(of: TestAccount.whs.getName()))
        }
        
        let greetingUserLabel = app.staticTexts["greetingUserLabel"]
        XCTAssertNotNil(greetingUserLabel.label.range(of: TestHelpers.getCurrentGreeting()))
        TestHelpers.takeScreenshot(inTestCase: self)
        if UIDevice.is_iPhone(){
            app.buttons["sideMenuButton"].tap()
        }
        XCTAssert(app.staticTexts["Log out"].exists)
        
        if UIDevice.is_iPhone(){
            app.buttons["closeButton"].tap()
        }
        XCTAssert(greetingUserLabel.exists)
    }
    
    /**
     - Description: 2.3 - Access Side Navigation Menu
     */
    func test_TC2a03_AccessSideNavigationMenu() throws {
        let app = TestHelpers.startAndWaitForABit()
        
        let greetingUserLabel = app.staticTexts["greetingUserLabel"]
        if !LoginTestHelper.didLoginIfNot(inTestCase: self){
            XCTAssertNotNil(greetingUserLabel.label.range(of: TestAccount.whs.getName()))
        }
        
        if UIDevice.is_iPhone(){
            app.buttons["sideMenuButton"].tap()
        }
        XCTAssert(app.staticTexts["A R V E N T A"].exists)
        XCTAssert(app.staticTexts["RISK & COMPLIANCE"].exists)
        
        XCTAssert(app.staticTexts["Home"].exists)
        
        XCTAssert(app.staticTexts["Profile"].exists)
        XCTAssert(app.staticTexts["Settings"].exists)
        XCTAssert(app.staticTexts["Log out"].exists)
        TestHelpers.takeScreenshot(inTestCase: self)
        
        if UIDevice.is_iPhone(){
            app.buttons["closeButton"].tap()
        }
        XCTAssert(greetingUserLabel.exists)
    }
}
