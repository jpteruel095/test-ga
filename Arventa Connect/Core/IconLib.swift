//
//  IconLib.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

struct ArventaFontIcon {
    var hexString: String
    
    func getUnicode() -> String{
        let inputText = hexString.replacingOccurrences(of: "\\", with: "")
        guard let character = Int(inputText, radix: 16)
                        .map({ input -> Character in
                            guard let scaled = UnicodeScalar(input) else{
                                return "t"
                            }
                            return Character( scaled )
        }) else{
            return ""
        }
        
        return String(character)
    }
    
    static func getUnicodeForIcon(named: String) -> String?{
        let json = Helpers.loadJSONFromResource(named: "icon-arventa-font")
        guard let hex = json[named].string else{
            return nil
        }
        return ArventaFontIcon(hexString: hex).getUnicode()
    }
}
