//
//  ArventaWeb+Auth.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation

extension ArventaWeb{
    func signIn(request: SignInRequest, completion:@escaping((UserToken?, Error?) -> Void)){
        Endpoint.token.request(parameters: request.getFinalParameters(), completion: { (json, error) in
            if let error = error{
                completion(nil, error)
                return
            }
            
            //check response here for json
            guard let json = json?.dictionaryObject,
                  let userToken = UserToken(JSON: json) else{
                completion(nil, Helpers.makeError(with: "Impossible..."))
                return
            }
            
            if userToken.isMultifactorRequired{
                completion(userToken, nil)
                return
            }
            
            userToken.saveToken()
            completion(userToken, nil)
            NotificationCenter.default.post(name: .userDidLogin, object: nil)
        })
    }
    
    func verify(request: VerificationRequest, completion:@escaping((UserToken?, Error?) -> Void)){
        Endpoint.token.request(parameters: request.getFinalParameters(), completion: { (json, error) in
            if let error = error{
                completion(nil, error)
                return
            }
            
            //check response here for json
            guard let json = json?.dictionaryObject,
                  let userToken = UserToken(JSON: json) else{
                completion(nil, Helpers.makeError(with: "Impossible..."))
                return
            }
            
            userToken.saveToken()
            completion(userToken, nil)
            NotificationCenter.default.post(name: .userDidLogin, object: nil)
        })
    }
    
    func refreshToken(completion: @escaping((UserToken?, Error?) -> Void)){
        guard let refreshToken = UserToken.current?.refreshToken else {
            completion(nil, Helpers.makeError(with: "Token expired", code: 401))
            return
        }
        
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        Endpoint.token.request(parameters: request.getFinalParameters(), completion: { (json, error) in
            if let error = error{
                completion(nil, error)
                return
            }
            
            //check response here for json
            guard let json = json?.dictionaryObject,
                  let userToken = UserToken(JSON: json) else{
                completion(nil, Helpers.makeError(with: "Token Expired.", code: 401))
                return
            }
            
            userToken.saveToken()
            completion(userToken, nil)
        })
    }
    
//    func forgot(request: ForgotPasswordRequest, completion:@escaping((Error?) -> Void)){
//        Endpoint.forgot.request(parameters: request.getParameters(), completion: { (json, error) in
//            if let error = error{
//                completion(error)
//                return
//            }
//            
//            //check response here for json
//            completion(nil)
//        })
//    }
}
