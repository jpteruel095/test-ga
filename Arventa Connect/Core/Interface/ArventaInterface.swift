//
//  ArventaInterface.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation

class ArventaInterface{
    static var shared = ArventaInterface()
    
    func signIn(request: SignInRequest, completion:@escaping((Error?) -> Void)){
        ArventaWeb.shared.signIn(request: request, completion: completion)
    }
}
