//
//  DB+Product.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

extension ArventaDB{
    func insertProduct(_ product: Product) throws{
        //execute INSERT STATEMENT here and save
        //if failed to save, shall throw Error
        
        //if success, shall trigger syncing
        NotificationCenter.default.post(name: .databaseDidUpdate, object: product)
    }
}
