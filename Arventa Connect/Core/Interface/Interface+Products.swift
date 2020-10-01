//
//  Interface+Products.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

extension ArventaInterface{
    func saveProduct(_ product: Product, completion: @escaping(Error?) -> Void){
        do{
            try ArventaDB.shared.insertProduct(product)
            completion(nil)
        }catch{
            completion(error)
        }
    }
    
    func getProducts(completion: @escaping([Product], Error?) -> Void){
        do{
            let products = try ArventaDB.shared.retrieveProductsFromDB()
            completion(products, nil)
        }catch{
            print("Error while retrieving products", error)
            completion([], error)
        }
    }
}
