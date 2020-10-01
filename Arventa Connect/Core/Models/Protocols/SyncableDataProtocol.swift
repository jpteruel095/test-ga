//
//  DBDataProtocol.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import Foundation

protocol SyncableDataProtocol {
    var id: Int? { get set }
    var serverId: Int? { get set }
    var created_at: Date? { get set }
    var last_update_at: Date? { get set }
    var last_sync_at: Date? { get set }
    var last_failed_at: Date? { get set }
}

extension SyncableDataProtocol{
    var isSyncable: Bool{
        guard let updateDate = last_update_at,
              let syncDate = last_sync_at else{
            return true
        }
        
        return updateDate.compare(.isLater(than: syncDate))
    }
}
