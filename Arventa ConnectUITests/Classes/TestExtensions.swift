//
//  TestExtensions.swift
//  Arventa ConnectUITests
//
//  Created by John Patrick Teruel on 10/6/20.
//

import UIKit

extension UIDevice{
    static func is_iPhone() -> Bool{
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static func is_iPad() -> Bool{
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
