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
            //will execute only if exists
            app.buttons["sideMenuButton"].tap()
            app.staticTexts["Log out"]
                .coordinate(withNormalizedOffset: .zero)
                .tap()
            LoginTestHelper.validateLoginPage()
            return true
        }
        return false
    }
    
    public class func didLoginIfNot(account: TestAccount = .whs, inTestCase testCase: XCTestCase?) -> Bool{
        let app = XCUIApplication()
        if app.textFields["Username"].exists {
            self.enterCredentialsAndTapLogin(username: account.getUsername(),
                                             password: account.getPassword())
            
            let greetingUserLabel = app.staticTexts["greetingUserLabel"]
            let exists = NSPredicate(format: "exists == 1")
            testCase?.expectation(for: exists, evaluatedWith: greetingUserLabel, handler: nil)
            testCase?.waitForExpectations(timeout: 10, handler: nil)
            
            XCTAssertNotNil(greetingUserLabel.label.range(of: account.getName()))
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

enum TestAccount: CaseIterable{
    case whs
    case msds
    case sm
    case pg
    case fm
    case cc
    
    func getUsername(withCode: Bool = false) -> String{
        switch self {
        case .whs:
            return "whs_numlock"
        case .msds:
            return "msds_rogomi"
        case .sm:
            return "sm_rogomi"
        case .pg:
            return "pg_rogomi"
        case .fm:
            return "fm_rogomi"
        case .cc:
            return "cc_rogomi"
        }
    }
    
    func getPassword() -> String{
        return "watsoN#12345"
    }
    
    var appName: String{
        switch self {
        case .whs:
            return "WHS Monitor"
        case .msds:
            return "MSDS"
        case .sm:
            return "Store Manifest"
        case .pg:
            return "Pest Genie"
        case .fm:
            return "Farm Minder"
        case .cc:
            return "Chemical Caddy"
        }
    }
    
    func getName() -> String{
        switch self {
        case .whs:
            return "whs_numlock Rogomi"
        case .msds:
            return "msds_rogomi Rogomi"
        case .sm:
            return "sm_rogomi Rogomi"
        case .pg:
            return "pg_rogomi Rogomi"
        case .fm:
            return "fm_rogomi Rogomi"
        case .cc:
            return "cc_rogomi Rogomi"
        }
    }
}
