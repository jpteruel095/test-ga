//
//  Arventa_ConnectTests.swift
//  Arventa ConnectTests
//
//  Created by John Patrick Teruel on 9/22/20.
//

import XCTest
@testable import Arventa_Connect

class Arventa_ConnectTests: XCTestCase {

    var mockVC: UIViewController{
        // Mock View Controller Creation
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let vc = UIViewController()
        window.rootViewController = vc
        
        return vc
    }
    func testArventaWeb() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // Login Endpoint Test
        XCTAssertNotNil(ArventaWeb.shared.reachability)
        XCTAssertTrue(ArventaWeb.Endpoint.token.isGuest)
        XCTAssert(ArventaWeb.Endpoint.token.httpMethod == .post)
        XCTAssertNoThrow(ArventaWeb.Endpoint.token.request())
    }
    
    func testHelpers() throws{
        // Test Show Message Alert View
        let mock1 = mockVC
        Helpers.showMessageAlertView(viewController: mock1, title: "Test Alert", message: "You have seen this test alert.")
        
        guard let alert = mock1.presentedViewController as? UIAlertController else{
            XCTFail("No alert presented")
            return
        }
        XCTAssertEqual(alert.title, "Test Alert")
        XCTAssertEqual(alert.message, "You have seen this test alert.")
        
        // Test Action Sheet
        let mock2 = mockVC
        Helpers.showActionSheet(viewController: mock2, title: "Test Sheet", actions: [
            UIAlertAction(title: "Button 1", style: .default, handler: nil),
            UIAlertAction(title: "Button 2", style: .default, handler: nil),
            UIAlertAction(title: "Button 3", style: .default, handler: nil),
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ])
        guard let actionSheet = mock2.presentedViewController as? UIAlertController else{
            XCTFail("No action sheet presented")
            return
        }
        
        XCTAssertEqual(actionSheet.title, "Test Sheet")
        XCTAssertEqual(actionSheet.actions.count, 4)
        
        XCTAssertEqual(Helpers.makeOfflineError().localizedDescription, "You are currently offline.")
    }
    
    func testExtensions() throws{
        let testString = """
              This is a test string


        """

        XCTAssertEqual(testString.trimmed, "This is a test string")
        XCTAssertNotNil(testString.nullableTrimmed)
        XCTAssertNil("       ".nullableTrimmed)
        XCTAssertNotNil("11/12/1995".toDate(withFormat: "MM/dd/yyyy"))
        XCTAssertNil("11/12/1995".toDate())
        XCTAssertEqual("This is a test string for 21 days".convertedToSlug(), "this-is-a-test-string-for-21-days")
        XCTAssertTrue("test@rogomi.com".isValidEmail())
        XCTAssertFalse("usern12345".isValidEmail())
        
        let field = UITextField()
        
        field.text = "     1 Test string      "
        XCTAssertEqual(field.trimmedText, "1 Test string")
        XCTAssertNotNil(field.nullableTrimmmedText)
        
        field.text = "        "
        XCTAssertNil(field.nullableTrimmmedText)
        
        field.text = " One "
        XCTAssertNil(field.parsedInteger)
        
        field.text = " 5 "
        XCTAssertEqual(field.parsedInteger, 5)
    }
}
