//
//  ArventaDB.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/24/20.
//

import Foundation

class ArventaDB{
    static var shared = ArventaDB()
    
    let licenseKey = "OmNpZDowMDExVjAwMDAyMWNSaEtRQVU6cGxhdGZvcm06MTA6ZXhwaXJlOm5ldmVyOnZlcnNpb246MTpobWFjOjY1NzViMTJkMzVlZTM5MmI0ZGIzNWMyMjZjMGQ0ZjZkNjBiYTJlOTg="
    let password = "123456789"
    
    // DB Values
    var userDB : OpaquePointer?
    var referencesDB : OpaquePointer?
}
