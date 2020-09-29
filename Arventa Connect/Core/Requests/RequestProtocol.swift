//
//  RequestProtocol.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Alamofire
import SwiftyJSON

public protocol RequestProtocol{
    ///Gets the Parameters for Alamofire request
    var excludedKeys: [String] { get }
}

public extension RequestProtocol{
    var excludedKeys: [String] {
        get{
            return []
        }
    }
    ///Returns the default Parameters with keys based from the variable names
    func getParameters() -> Parameters{
        var parameters: Parameters = [:]
        var listPropertiesWithValues: ((Mirror?) -> Void)!
        listPropertiesWithValues = { reflect in
            let mirror = reflect ?? Mirror(reflecting: self)
            if mirror.superclassMirror != nil {
                listPropertiesWithValues(mirror.superclassMirror)
            }

            for (_, attr) in mirror.children.enumerated() {
                if let property_name = attr.label,
                   property_name != "excludedKeys",
                    !self.excludedKeys.contains(property_name){
                    parameters[property_name] = attr.value
                }
            }
        }
        
        listPropertiesWithValues(nil)
        return parameters
    }
}
