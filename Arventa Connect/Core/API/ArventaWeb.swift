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
        static let domainName = "www.arventa.com.au"
        static let scheme = "https"
        // Prod
//        static let domainName = "prod.arventa.com"
//        static let scheme = "https"
        
        static let host = "\(scheme)://\(domainName)/"
        
        static let clientID = "80192df8-ec38-4ca6-9669-6bf96c6f5bba"
        static let clientKey = "1d5565a5-6b9a-481a-a326-e33a8dcd3287"
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
