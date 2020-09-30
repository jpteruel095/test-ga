//
//  TestHelpers.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest

class TestHelpers{
    public class func validateLoginPage(app: XCUIApplication, emptyFields: Bool = true){
        XCTAssert(app.staticTexts["A R V E N T A"].exists)
        XCTAssert(app.staticTexts["RISK & COMPLIANCE"].exists)
        if emptyFields{
            XCTAssert(app.textFields["Username"].exists)
            XCTAssert(app.secureTextFields["Password"].exists)
        }
        XCTAssert(app.buttons["Forgot Password?"].exists)
        XCTAssert(app.buttons["LOG IN"].exists)
    }
    
    public class func enterCredentialsAndTapLogin(app: XCUIApplication, username: String, password: String){
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText(username)
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText(password)
        
        app.keyboards.buttons["done"].tap()
        app.buttons["LOG IN"].tap()
    }
}
