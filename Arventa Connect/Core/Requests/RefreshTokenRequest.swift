//
//  RefreshTokenRequest.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/30/20.
//

import Alamofire

struct RefreshTokenRequest: RequestProtocol{
    let refreshToken: String
    
    func getFinalParameters() -> Parameters{
        var params = self.getParameters()
        
        params["grantType"] = "refreshToken"
        params["clientId"] = ArventaWeb.Constants.clientID
        params["clientKey"] = ArventaWeb.Constants.clientKey
        
        return params
    }
}
