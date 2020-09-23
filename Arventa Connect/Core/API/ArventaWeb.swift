//
//  ArventaWeb.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import Foundation
import Alamofire
import Reachability

class ArventaWeb{
    // MARK: Singleton
    static var shared = ArventaWeb()
    
    // MARK: Constants
    struct Constants{
        // Dev
        static let domainName = "dev.arventa.ph"
        static let scheme = "http"
        // Prod
//        static let domainName = "prod.arventa.com"
//        static let scheme = "https"
        
        static let host = "\(scheme)://\(domainName)/"
    }
    
    var reachability: Reachability? = {
        do{
            let reachability = try Reachability()
            reachability.whenReachable = { _ in
                
            }
            reachability.whenUnreachable = { _ in
                
            }
            try reachability.startNotifier()
            return reachability
        }catch{
            return nil
        }
    }()
}
