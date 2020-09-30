//
//  DB+Demo.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

extension ArventaDB{
//    func createTestDBOnce() throws {
//        guard let docDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
//            print("Nvm")
//            return
//        }
//        
//        let dbPath = URL(fileURLWithPath: docDirectory).appendingPathComponent("test.db").absoluteString
//        
//        var rc: Int32
//        var stmt: OpaquePointer? = nil
//        rc = sqlite3_open(dbPath, &self.db)
//        if (rc != SQLITE_OK) {
//            let errmsg = String(cString: sqlite3_errmsg(self.db))
//            print("Error opening database: \(errmsg)")
//            throw Helpers.makeError(with: errmsg)
//        }
//        
//        let licensePragma = ("PRAGMA cipher_license = '\(licenseKey)';" as NSString).utf8String
//        rc = sqlite3_exec(self.db, licensePragma, nil, nil, nil)
//        if (rc != SQLITE_OK) {
//            let errmsg = String(cString: sqlite3_errmsg(self.db))
//            print("Error with cipher_license: \(errmsg)")
//            throw Helpers.makeError(with: errmsg)
//        }
//    
//        rc = sqlite3_key(self.db, (password as NSString).utf8String, Int32(password.utf8CString.count))
//        if (rc != SQLITE_OK) {
//            let errmsg = String(cString: sqlite3_errmsg(self.db))
//            print("Error setting key: \(errmsg)")
//            throw Helpers.makeError(with: errmsg)
//        }
//        
//        let cipherLicense = ("PRAGMA cipher_license;" as NSString).utf8String
//        rc = sqlite3_prepare(self.db, cipherLicense, -1, &stmt, nil);
//        rc = sqlite3_step(stmt);
//        if (rc == SQLITE_ROW){
//            rc = sqlite3_column_int(stmt, 0);
//            sqlite3_finalize(stmt);
//            print("PRAGMA cipher_license; returned \(rc)");
//            if(rc == SQLITE_AUTH){
//                let errmsg = String(cString: sqlite3_errmsg(self.db))
//                print("Failed to apply license key: \(errmsg)")
//                sqlite3_close(self.db);
//                self.db = nil;
//                throw Helpers.makeError(with: errmsg)
//            }
//        }
//        
//        let createTableQuery = ("CREATE TABLE IF NOT EXISTS t1(a,b);" as NSString).utf8String
//        rc = sqlite3_exec(self.db, createTableQuery, nil, nil, nil)
//        if (rc != SQLITE_OK){
//            let errmsg = String(cString: sqlite3_errmsg(self.db))
//            print("Failed to create table: \(errmsg)")
//            throw Helpers.makeError(with: errmsg)
//        }
//        
//        self.insertData()
//    }
//    
//    
//    func insertData() {
//        var rc: Int32
//        var stmt: OpaquePointer?
//        let insertQuery = ("INSERT INTO t1(a,b) VALUES(?, ?)" as NSString).utf8String
//        rc = sqlite3_prepare(self.db, insertQuery, -1, &stmt, nil);
//        if (rc != SQLITE_OK) {
//            let errmsg = String(cString: sqlite3_errmsg(self.db))
//            print("Failed to prepare insert statement: \(errmsg)");
//            return;
//        }
//        let oneInsert = ("one for the money" as NSString).utf8String
//        sqlite3_bind_text(stmt, 1, oneInsert, -1, nil);
//        let twoInsert = ("two for the show" as NSString).utf8String
//        sqlite3_bind_text(stmt, 2, twoInsert, -1, nil);
//        rc = sqlite3_step(stmt);
//        if(rc != SQLITE_DONE){
//            let errmsg = String(cString: sqlite3_errmsg(self.db))
//            print("Failed to insert data: \(errmsg)");
//            return;
//        }
//        sqlite3_finalize(stmt);
//    }
//    
//    
//    func getDemoDBValue() throws -> String{
//        var rc: Int32
//        if (self.db == nil) {
//            try self.createTestDBOnce()
//        }
//        
//        
//        let buffer: NSMutableString = ""
//        var stmt: OpaquePointer?
//        let selectQuery = ("SELECT * FROM t1;" as NSString).utf8String
//        sqlite3_prepare(self.db, selectQuery, -1, &stmt, nil);
//        rc = sqlite3_step(stmt)
//        while (rc == SQLITE_ROW) {
//            buffer.append(String(format: "a:%s b:%s\n", sqlite3_column_text(stmt, 0), sqlite3_column_text(stmt, 1)))
//            rc = sqlite3_step(stmt)
//        }
//        print(buffer)
//        return buffer as String
//    }
}
