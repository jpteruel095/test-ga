//
//  Interface+Dashboard.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation

extension ArventaInterface{
    func getMenuItems(completion: @escaping([MenuItem], Error?) -> Void){
        completion(MenuItem.retrieveAll(), nil)
    }
    
    func getProducts(completion: @escaping([String: Any]?, Error?) -> Void){
        do{
            let product = try ArventaDB.shared.retrieveProductsFromDB()
            completion(product, nil)
        }catch{
            print("Error while retrieving products", error)
            completion(nil, error)
        }
    }
}
