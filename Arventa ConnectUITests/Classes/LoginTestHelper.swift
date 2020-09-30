//
//  LoginTestHelper.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest

class LoginTestHelper{
    public class func validateLoginPage(emptyFields: Bool = true){
        let app = XCUIApplication()
        XCTAssert(app.staticTexts["A R V E N T A"].exists)
        XCTAssert(app.staticTexts["RISK & COMPLIANCE"].exists)
        if emptyFields{
            XCTAssert(app.textFields["Username"].exists)
            XCTAssert(app.secureTextFields["Password"].exists)
        }
        XCTAssert(app.buttons["Forgot Password?"].exists)
        XCTAssert(app.buttons["LOG IN"].exists)
    }
    
    public class func didForceLogout() -> Bool{
        let app = XCUIApplication()
        if app.staticTexts["greetingUserLabel"].exists {
            //will execute only if exists - it works
            app.buttons["sideMenuButton"].tap()
            app.staticTexts["Log out"]
                .coordinate(withNormalizedOffset: .zero)
                .tap()
            LoginTestHelper.validateLoginPage()
            return true
        }
        return false
    }
    
    public class func enterOTPCode(code: String){
        let app = XCUIApplication()
        let str = Array(code).map { String($0) }
        str.forEach { (num) in
            app.keys[num].tap()
        }
    }
    
    public class func enterCredentialsAndTapLogin(username: String, password: String){
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText(username)
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText(password)
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.buttons["LOG IN"].tap()
    }
}
