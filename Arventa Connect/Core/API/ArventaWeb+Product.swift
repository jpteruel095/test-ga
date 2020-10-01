//
//  ArventaWeb+Product.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation
import Alamofire

extension ArventaWeb{
    func uploadProduct(product: Product, completion: ((Product?, Error?) -> Void)? = nil){
        let params: Parameters = [
            "name": product.name!
        ]
        Endpoint.savetestproduct.request(parameters: params, completion: { (json, error) in
            if let error = error{
//                completion?(nil, error)
                
                product.serverId = 100
                completion?(product, nil)
                return
            }
            
            product.serverId = json?["serverID"].int
            completion?(product, nil)
        })
    }
}
