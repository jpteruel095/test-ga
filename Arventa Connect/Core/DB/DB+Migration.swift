//
//  DB+Migration.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

extension ArventaDB{
    func initializeUserDB() throws{
        guard let user = User.current,
              let userID = user.userID else{
            return
        }
        
        guard let docDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
            return
        }
        
        let dbPath = URL(fileURLWithPath: docDirectory)
            .appendingPathComponent("\(userID).db")
            .absoluteString
        
        var rc: Int32
        var stmt: OpaquePointer? = nil
        // Initialize DB
        rc = sqlite3_open(dbPath, &self.userDB)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Error opening database: \(errmsg)")
            throw Helpers.makeError(with: errmsg)
        }
        
        // Apply License
        let licensePragma = ("PRAGMA cipher_license = '\(licenseKey)';" as NSString).utf8String
        rc = sqlite3_exec(self.userDB, licensePragma, nil, nil, nil)
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Error with cipher_license: \(errmsg)")
            throw Helpers.makeError(with: errmsg)
        }
        
        rc = sqlite3_key(self.userDB, (password as NSString).utf8String, Int32(password.utf8CString.count))
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Error setting key: \(errmsg)")
            throw Helpers.makeError(with: errmsg)
        }
        
        let cipherLicense = ("PRAGMA cipher_license;" as NSString).utf8String
        rc = sqlite3_prepare(self.userDB, cipherLicense, -1, &stmt, nil);
        rc = sqlite3_step(stmt);
        if (rc == SQLITE_ROW){
            rc = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
            print("PRAGMA cipher_license; returned \(rc)");
            if(rc == SQLITE_AUTH){
                let errmsg = String(cString: sqlite3_errmsg(self.userDB))
                print("Failed to apply license key: \(errmsg)")
                sqlite3_close(self.userDB);
                self.userDB = nil;
                throw Helpers.makeError(with: errmsg)
            }
        }
        
        try createDemoProductTable()
    }
    
    fileprivate func createDemoProductTable() throws{
        let fields = [
            "id", "name", "created_at", "last_updated_at", "last_sync_at", "last_failed_at"
        ]
        let createTableQuery = (queryForCreatingTableIfNotExist(tableName: "demoProducts", fields: fields) as NSString).utf8String
        var rc = sqlite3_exec(self.userDB, createTableQuery, nil, nil, nil)
        if (rc != SQLITE_OK){
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Failed to create table: \(errmsg)")
            throw Helpers.makeError(with: errmsg)
        }
        
        let dict: [String: Any] = [
            "id": 1,
            "name": "Ryzen 5 3600X",
            "created_at": Date().toString(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        ]
        
        var keys: [String] = []
        var values: [Any] = []
        
        let _ = dict.map { (key, value) -> Any in
            keys.append(key)
            values.append(value)
            return key
        }
        
        insertIntoTable(tableName: "demoProducts",
                        fields: keys,
                        values: values)
    }
    
    func queryForCreatingTableIfNotExist(tableName: String, fields: [String]) -> String{
        return "CREATE TABLE IF NOT EXISTS \(tableName)(\(fields.joined(separator: ","))"
    }
    
    func insertIntoTable(tableName: String, fields: [String], values: [Any]){
        var stmt: OpaquePointer?
        let insertQuery = ("INSERT INTO \(tableName)(\(fields.joined(separator: ",")) VALUES(\(fields.map{ _ -> String in return "?"})" as NSString).utf8String
        
        var rc = sqlite3_prepare(self.userDB, insertQuery, -1, &stmt, nil);
        if (rc != SQLITE_OK) {
            let errmsg = String(cString: sqlite3_errmsg(self.userDB))
            print("Failed to prepare insert statement: \(errmsg)");
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
        }
        sqlite3_finalize(stmt);
    }
    
//    func retrieveProductsFromDB() throws{
//        var rc: Int32
//        if (self.userDB == nil) {
//            try self.initializeUserDB()
//        }
//        
//        
//        let buffer: NSMutableString = ""
//        var stmt: OpaquePointer?
//        let selectQuery = ("SELECT * FROM t1;" as NSString).utf8String
//        sqlite3_prepare(self.userDB, selectQuery, -1, &stmt, nil);
//        rc = sqlite3_step(stmt)
//        while (rc == SQLITE_ROW) {
//            buffer.append(String(format: "a:%s b:%s\n", sqlite3_column_text(stmt, 0), sqlite3_column_text(stmt, 1)))
//            rc = sqlite3_step(stmt)
//        }
//        print(buffer)
//        return buffer as String
//    }
}
