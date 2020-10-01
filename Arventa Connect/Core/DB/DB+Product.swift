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
        let dict: [String: Any] = [
            "id": 1,
            "name": product.name!,
            "created_at": Date().toString(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
            "last_updated_at": Date().toString(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        ]
        
        var keys: [String] = []
        var values: [Any] = []
        
        let _ = dict.map { (key, value) -> Any in
            keys.append(key)
            values.append(value)
            return key
        }
        
        //if failed to save, shall throw Error
        try insertIntoTable(tableName: "demoProducts",
                        fields: keys,
                        values: values)
        
        //if success, shall trigger syncing
        NotificationCenter.default.post(name: .databaseDidUpdate, object: product)
    }
    
    func retrieveProductsFromDB() throws -> [Product]{
        var products: [[String: Any?]] = []
        var rc: Int32
        if (self.userDB == nil) {
            try initializeUserDB()
        }

        var stmt: OpaquePointer?
        let selectQuery = ("SELECT * FROM demoProducts;" as NSString).utf8String
        sqlite3_prepare(self.userDB, selectQuery, -1, &stmt, nil);
        rc = sqlite3_step(stmt)
        
        while (rc == SQLITE_ROW) {
            print("Columns: ", sqlite3_column_count(stmt))
            
            var rawDict: [String: Any?] = [:]
            for i in 0 ... sqlite3_column_count(stmt) - 1{
                let key = String(format: "%s", sqlite3_column_name(stmt, i))
                let type = sqlite3_column_type(stmt, i)
                var value: Any?
                if type == SQLITE_INTEGER{
                    value = sqlite3_column_int(stmt, i)
                }
                else if type == SQLITE_TEXT{
                    value = String(format: "%s", sqlite3_column_text(stmt, i))
                }
                else if type == SQLITE_NULL{
                    value = nil
                }
                rawDict[key] = value
            }
            
            products.append(rawDict)
            rc = sqlite3_step(stmt)
        }
        return products.compactMap { (rawProduct) -> Product? in
            guard let raw = rawProduct as? [String: Any],
                  let product = Product(JSON: raw) else{
                return nil
            }
            
            return product
        }
    }
    
    func updateServerID(_ id: Int, forProduct: Product){
        // update query
        print("Will update sync values here")
        //but do not trigger database update event
    }
}
