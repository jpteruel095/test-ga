//
//  Product.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import ObjectMapper

class Product: Mappable, SyncableDataProtocol{
    var id: Int = 1
    var serverId: Int?
    var name: String?
    
    var created_at: Date = Date()
    var last_updated_at: Date = Date()
    var last_synced_at: Date?
    var last_failed_at: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        serverId <- map["serverId"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let transform = DateFormatterTransform(dateFormatter: formatter)
        created_at <- (map["created_at"], transform)
        last_updated_at <- (map["last_updated_at"], transform)
        last_synced_at <- (map["last_synced_at"], transform)
        last_failed_at <- (map["last_failed_at"], transform)
    }
}
