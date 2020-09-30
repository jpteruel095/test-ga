//
//  ArventaWeb+Profile.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/30/20.
//

import Foundation

extension ArventaWeb{
    func refreshUserDetails(completion: @escaping((User?, Error?) -> Void)){
        Endpoint.useridentity.request(completion: { (json, error) in
            if let error = error{
                completion(nil, error)
                return
            }
            
            guard let jsonString = json?.rawString(),
                let user = User(JSONString: jsonString) else{
                completion(nil, Helpers.makeError(with: "Could not retrieve user identity."))
                return
            }
            
            user.saveAsCurrentUser()
            completion(user, nil)
        })
    }
}
