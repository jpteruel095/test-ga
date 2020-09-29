//
//  NotificationCenter.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation

extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
    static let userDidLogout = Notification.Name("userDidLogout")
    
    static let databaseDidUpdate = Notification.Name("databaseDidUpdate")
    static let recordsDidRetrieve = Notification.Name("recordsDidRetrieve")
}
