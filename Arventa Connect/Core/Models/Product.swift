//
//  Product.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import ObjectMapper

class Product: Mappable, SyncableDataProtocol{
    var id: Int?
    var name: String?
    
    var created_at: Date?
    var last_update_at: Date?
    var last_sync_at: Date?
    var last_failed_at: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}
