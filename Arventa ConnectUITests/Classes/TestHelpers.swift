//
//  TestHelpers.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 9/30/20.
//

import XCTest
import SwiftDate

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
                                  shouldTakeScreenshot takeScreenshot: Bool = false,
                                  inTestCase testCase: XCTestCase?){
        let app = XCUIApplication()
        
        let alert = app.alerts[title]
        
        if shouldWait{
            let exists = NSPredicate(format: "exists == 1")
            testCase?.expectation(for: exists, evaluatedWith: alert, handler: nil)
            testCase?.waitForExpectations(timeout: seconds, handler: nil)
        }
        
        XCTAssert(alert.staticTexts[message].exists)
        if takeScreenshot {
            TestHelpers.takeScreenshot(inTestCase: testCase)
        }
        
        alert.buttons[buttonTitle].tap()
    }
    
    public class func expectActionSheet(title: String,
                                        andTap buttonTitle: String,
                                        butWait shouldWait: Bool = false,
                                        forUpTo seconds: Double = 10,
                                        shouldTakeScreenshot takeScreenshot: Bool = false,
                                        inTestCase testCase: XCTestCase?){
        let app = XCUIApplication()
        
        let actionsheet = app.sheets[title]
        
        if shouldWait{
            let exists = NSPredicate(format: "exists == 1")
            testCase?.expectation(for: exists, evaluatedWith: actionsheet, handler: nil)
            testCase?.waitForExpectations(timeout: seconds, handler: nil)
        }
        
        if takeScreenshot {
            TestHelpers.takeScreenshot(inTestCase: testCase)
        }
        
        actionsheet.buttons[buttonTitle].tap()
    }
    
    public class func takeScreenshot(inTestCase testCase: XCTestCase?) {
        let fullScreenshot = XCUIScreen.main.screenshot()
        let screenshot = XCTAttachment(screenshot: fullScreenshot)

        screenshot.lifetime = .keepAlways
        testCase?.add(screenshot)
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
    
    public class func getCurrentGreeting() -> String{
        let region = Region.init(calendar: Calendars.gregorian, zone: Zones.asiaManila, locale: Locales.english)
        let date = Date().convertTo(region: region)
        guard let midnight = date.dateBySet(hour: 0, min: 0, secs: 0),
            let noon = date.dateBySet(hour: 12, min: 0, secs: 0),
            let evening = date.dateBySet(hour: 18, min: 0, secs: 0) else{
            return "Guten Morgen"
        }
        
        let now = Date().convertTo(region: region)
        if now.isInRange(date: midnight, and: noon){
            return "Good morning"
        }else if now.isInRange(date: noon, and: evening){
            return "Good afternoon"
        }else{
            return "Good evening"
        }
    }
}
