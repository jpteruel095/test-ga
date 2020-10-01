//
//  AppTheme.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation
import ObjectMapper

class AppTheme: Mappable{
    static var standard: AppTheme{
        guard let theme = AppTheme(JSON: [:]) else{
            fatalError("Impossible...")
        }
        return theme
    }
    
    var backgroundColor: String = "FFFFFF"
    var backgroundGradientHex1: String = "636982"
    var backgroundGradientHex2: String = "4B516C"
    
    var logoName: String = "Arventa"
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}
