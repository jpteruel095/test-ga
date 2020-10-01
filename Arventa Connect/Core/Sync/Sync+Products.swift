//
//  Sync+Products.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

extension ArventaSync{
    func didStartSyncingProducts(attempts: Int = 1) -> Bool{
        if attempts > 3{
            return false
        }
        do{
            // retrieve all products
            let products = try ArventaDB.shared.retrieveProductsFromDB()
            // check for syncables
            let syncables = products.filter({$0.isSyncable})
            if let product = syncables.first{
                ArventaWeb.shared.uploadProduct(product: product){ newProduct, error in
                    if let error = error{
                        print(error)
                        //will attempt again
                        if !self.didStartSyncingProducts(attempts: attempts + 1) {
                            // mark as failed
                            try? ArventaDB.shared.markAsFailed(product: product)
                            self.isSyncing = false
                            self.startSyncing()
                        }
                        return
                    }
                    
                    do{
                        try ArventaDB.shared.updateServerID(newProduct!.serverId!, forProduct: newProduct!)
                        NotificationCenter.default.post(name: .databaseDidSync, object: nil)
                    }catch{
                        self.errorCounter += 1
                        print("Errors encountered: \(self.errorCounter)")
                        print(error)
                        return
                    }
                    
                    self.isSyncing = false
                    self.startSyncing() //again and again until no more syncable products are left
                }
                return true
            }
        }catch{
            print("Error occured while trying to push products")
        }
        
        // if there are no syncables, proceed with the next command
        return false
    }
}
