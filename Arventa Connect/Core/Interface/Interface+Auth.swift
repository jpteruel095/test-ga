//
//  Interface+Auth.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/30/20.
//

import Foundation

extension ArventaInterface{
    func signIn(request: SignInRequest, completion:@escaping((UserToken?, Error?) -> Void)){
        ArventaWeb.shared.signIn(request: request, completion: { token, error in
            if let error = error{
                completion(token, error)
                return
            }
            
            guard token?.isMultifactorRequired == false else{
                completion(token, error)
                return
            }
            
            ArventaWeb.shared.refreshUserDetails { (error) in
                if let error = error{
                    completion(token, error)
                    return
                }
                
                ArventaWeb.shared.getMenuItems { (error) in
                    completion(token, error)
                }
            }
        })
    }
    
    func verify(request: VerificationRequest, completion:@escaping((UserToken?, Error?) -> Void)){
        ArventaWeb.shared.verify(request: request, completion: { token, error in
            if let error = error{
                completion(token, error)
                return
            }
            
            ArventaWeb.shared.refreshUserDetails { (error) in
                if let error = error{
                    completion(token, error)
                    return
                }
                
                ArventaWeb.shared.getMenuItems { (error) in
                    completion(token, error)
                }
            }
        })
    }
    
    func signOut(){
        MenuItem.deleteAll()
        UserDefaults.clearObject(forKey: .userObject)
        UserDefaults.clearObject(forKey: .accessToken)
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
}
