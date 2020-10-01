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
            "id", "serverId", "name", "created_at", "last_updated_at", "last_synced_at", "last_failed_at"
        ]
        try self.createTableIfNotExist(tableName: "demoProducts", fields: fields)
    }
}
