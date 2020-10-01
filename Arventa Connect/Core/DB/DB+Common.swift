//
//  DB+Demo.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

extension ArventaDB{
    func createTableIfNotExist(tableName: String, fields: [String]) throws{
        let rawFields = fields.joined(separator: ",")
        let rawQuery = String(format: "CREATE TABLE IF NOT EXISTS %@(%@)",
                         tableName,
                         rawFields)
        let createTableQuery = (rawQuery as NSString).utf8String
        let rc = sqlite3_exec(self.userDB, createTableQuery, nil, nil, nil)
        if (rc != SQLITE_OK){
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Failed to create table: \(errmsg)")
            throw Helpers.makeError(with: errmsg)
        }
    }
    
    func insertIntoTable(tableName: String, dict: [String: Any]) throws{
        var fields: [String] = []
        var values: [Any] = []
        
        let _ = dict.map { (key, value) -> Any in
            fields.append(key)
            values.append(value)
            return key
        }
        
        var stmt: OpaquePointer?
        let rawFields = fields.joined(separator: ",")
        let rawValues = fields.map{ _ in "?"}.joined(separator: ",")
        
        let rawQuery = String(format: "INSERT INTO %@(%@) VALUES(%@)",
                         tableName,
                         rawFields,
                         rawValues)
        
        let insertQuery = (rawQuery as NSString).utf8String
        var rc = sqlite3_prepare(self.userDB, insertQuery, -1, &stmt, nil);
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Failed to prepare insert statement: \(errmsg)");
            throw Helpers.makeError(with: errmsg)
        }
        
        var i: Int32 = 1
        values.forEach { (val) in
            if let val = val as? String{
                sqlite3_bind_text(stmt, i, (val as NSString).utf8String, -1, nil);
            }else if let val = val as? Int{
                sqlite3_bind_int(stmt, i, Int32(val))
            }
            i += 1
        }
        rc = sqlite3_step(stmt);
        if(rc != SQLITE_DONE){
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Failed to insert data: \(errmsg)");
            throw Helpers.makeError(with: errmsg)
        }
        sqlite3_finalize(stmt);
    }
    
    func updateTable(tableName: String, set dict: [String: Any], where id: Int) throws{
        var updatableFields: [String] = []
        var values: [Any] = []
        
        let _ = dict.map { (key, value) -> Any in
            updatableFields.append(String(format: "%@ = ?", key))
            values.append(value)
            return key
        }
        
        var stmt: OpaquePointer?
        let rawFields = updatableFields.joined(separator: ",")
        let rawQuery = String(format: "UPDATE %@ SET %@ WHERE id = %d",
                         tableName,
                         rawFields,
                         id)
        
        let updateQuery = (rawQuery as NSString).utf8String
        var rc = sqlite3_prepare(self.userDB, updateQuery, -1, &stmt, nil);
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Failed to prepare insert statement: \(errmsg)");
            throw Helpers.makeError(with: errmsg)
        }
        
        var i: Int32 = 1
        values.forEach { (val) in
            if let val = val as? String{
                sqlite3_bind_text(stmt, i, (val as NSString).utf8String, -1, nil);
            }else if let val = val as? Int{
                sqlite3_bind_int(stmt, i, Int32(val))
            }
            i += 1
        }
        
        rc = sqlite3_step(stmt);
        if(rc != SQLITE_DONE){
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Failed to insert data: \(errmsg)");
            throw Helpers.makeError(with: errmsg)
        }
        
        sqlite3_finalize(stmt);
    }
    
    func getLatestID(forKey key: UserDefaultKey) -> Int{
        var id = 1
        
        if let storedID = UserDefaults.getObject(forKey: key) as? Int{
            id = storedID + 1
        }
        
        UserDefaults.storeObject(id, forKey: key)
        return id
    }
}
