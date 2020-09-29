//
//  SignInRequeest.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//
import Alamofire

struct SignInRequest: RequestProtocol{
    let userName: String
    let password: String
    let app: ArventaApp
    
    var excludedKeys = ["app"]
    
    func getFinalParameters() -> Parameters{
        var params = self.getParameters()
        
        params["deviceId"] = UUID.deviceUUID
        params["scopes"] = "113"
        params["grantType"] = "password"
        params["clientId"] = ArventaWeb.Constants.clientID
        params["clientKey"] = ArventaWeb.Constants.clientKey
        params["applicationName"] = app.rawValue
        
        return params
    }
}

struct VerificationRequest: RequestProtocol{
    let code: String
    let securityCode: String
    
    func getFinalParameters() -> Parameters{
        var params = self.getParameters()
        
        params["grantType"] = "multifactorCode"
        params["clientId"] = ArventaWeb.Constants.clientID
        params["clientKey"] = ArventaWeb.Constants.clientKey
        
        return params
    }
}

struct ForgotPasswordRequest: RequestProtocol{
    let email: String
}

enum ArventaApp: String, CaseIterable{
    case WHSMONITOR
    case MSDS
    case STOREMANIFEST
    case PESTGENIE
    case FARMMINDER
    case CHEMICALCADDY
    
    var labelText: String {
        switch self {
        case .WHSMONITOR:
            return "WHS Monitor"
        case .MSDS:
            return "MSDS"
        case .STOREMANIFEST:
            return "Store Manifest"
        case .PESTGENIE:
            return "Pest Genie"
        case .FARMMINDER:
            return "Farm Minder"
        case .CHEMICALCADDY:
            return "Chemical Caddy"
        }
    }
    
    var subscriptionType: [String]{
        switch self{
        default:
            return ["60","70","96","160","250","300","600"]
        }
    }
}
