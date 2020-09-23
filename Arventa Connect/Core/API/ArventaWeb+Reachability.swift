//
//  ArventaWeb+Reachability.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import Foundation
import Reachability

extension ArventaWeb{
    func isOffline() -> Bool{
        guard let reachability = reachability else{
            return false
        }
        return reachability.connection == .unavailable
    }
}
