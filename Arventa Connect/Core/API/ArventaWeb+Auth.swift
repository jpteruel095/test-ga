//
//  ArventaWeb+Auth.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation

extension ArventaWeb{
    func signIn(request: SignInRequest, completion:@escaping((Error?) -> Void)){
        Endpoint.token.request(parameters: request.getFinalParameters(), completion: { (json, error) in
            if let error = error{
                completion(error)
                return
            }
            
            //check response here for json
            completion(nil)
        })
    }
    
    func verify(request: VerificationRequest, completion:@escaping((Error?) -> Void)){
        Endpoint.token.request(parameters: request.getFinalParameters(), completion: { (json, error) in
            if let error = error{
                completion(error)
                return
            }
            
            //check response here for json
            completion(nil)
        })
    }
    
    func forgot(request: ForgotPasswordRequest, completion:@escaping((Error?) -> Void)){
        Endpoint.forgot.request(parameters: request.getParameters(), completion: { (json, error) in
            if let error = error{
                completion(error)
                return
            }
            
            //check response here for json
            completion(nil)
        })
    }
}
