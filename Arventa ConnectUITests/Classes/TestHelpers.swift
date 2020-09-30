//
//  TestHelpers.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest

class TestHelpers{
    public class func tapOverStaticText(_ text: String){
        let app = XCUIApplication()
        app.staticTexts[text]
            .coordinate(withNormalizedOffset: .zero)
            .tap()
    }
    
    public class func expectAlert(withTitle title: String,
                                  andAssertMessage message: String,
                                  thenTap buttonTitle: String,
                                  butWait shouldWait: Bool = false,
                                  forUpTo seconds: Double = 10,
                                  inTestCase testCase: XCTestCase?){
        let app = XCUIApplication()
        
        let alert = app.alerts[title]
        
        if shouldWait{
            let exists = NSPredicate(format: "exists == 1")
            testCase?.expectation(for: exists, evaluatedWith: alert, handler: nil)
            testCase?.waitForExpectations(timeout: seconds, handler: nil)
        }
        
        XCTAssert(alert.staticTexts[message].exists)
        alert.buttons[buttonTitle].tap()
    }
    
    public class func expectActionSheet(title: String,
                                        andTap buttonTitle: String,
                                        butWait shouldWait: Bool = false,
                                        forUpTo seconds: Double = 10,
                                        inTestCase testCase: XCTestCase?){
        let app = XCUIApplication()
        
        let actionsheet = app.sheets[title]
        
        if shouldWait{
            let exists = NSPredicate(format: "exists == 1")
            testCase?.expectation(for: exists, evaluatedWith: actionsheet, handler: nil)
            testCase?.waitForExpectations(timeout: seconds, handler: nil)
        }
        
        actionsheet.buttons[buttonTitle].tap()
    }
    
    public class func executeWhileOffline(function: () -> Void){
        let app = XCUIApplication()
        
        let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settingsApp.launch()
        settingsApp.tables.cells["Airplane Mode"].tap()
        // Relaunch app without restarting it
        app.activate()
        
        //execute
        function()
        
        settingsApp.launch()
        settingsApp.tables.cells["Airplane Mode"].tap()

        // Relaunch app without restarting it
        app.activate()
    }
}
