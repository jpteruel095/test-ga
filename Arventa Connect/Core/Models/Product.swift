//
//  Product.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import ObjectMapper

class Product: Mappable, SyncableDataProtocol{
    var id: Int?
    var serverId: Int?
    var name: String?
    
    var created_at: Date?
    var last_update_at: Date?
    var last_sync_at: Date?
    var last_failed_at: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
        created_at <- (map["created_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        last_update_at <- (map["last_update_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        last_sync_at <- (map["last_sync_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        last_failed_at <- (map["last_failed_at"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
    }
}
