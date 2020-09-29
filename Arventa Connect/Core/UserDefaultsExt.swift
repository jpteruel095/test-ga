//
//  UserDefaultsExt.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation

enum UserDefaultKey: String {
    typealias RawValue = String
    
    case accessToken
    case userObject
    
    case loginHistory
}

extension UserDefaults {
    static func storeObject(_ value: Any?, forKey key: UserDefaultKey){
        standard.set(value, forKey: key.rawValue)
        standard.synchronize()
    }
    
    static func getObject(forKey key: UserDefaultKey) -> Any?{
        return standard.value(forKey: key.rawValue)
    }
    
    static func clearObject(forKey key: UserDefaultKey){
        return standard.removeObject(forKey: key.rawValue)
    }
}
