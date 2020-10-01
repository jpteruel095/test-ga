//
//  DBDataProtocol.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

protocol SyncableDataProtocol {
    var id: Int { get set }
    var serverId: Int? { get set }
    var created_at: Date { get set }
    var last_updated_at: Date { get set }
    var last_synced_at: Date? { get set }
    var last_failed_at: Date? { get set }
}

extension SyncableDataProtocol{
    var isSyncable: Bool{
        if last_failed_at != nil{
            return false
        }
        
        guard let _ = serverId,
              let syncDate = last_synced_at else{
            return true
        }
        
        return last_updated_at.addingTimeInterval(-60).compare(.isLater(than: syncDate))
    }
}
