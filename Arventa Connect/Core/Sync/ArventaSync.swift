//
//  ArventaSync.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/24/20.
//

import UIKit
import Reachability

typealias SyncFunction = ((Error?) -> Void)

class ArventaSync: NSObject{
    static var shared = ArventaSync()
    
    // MARK: App Syncing Variables
    var isSyncing = false
    var shouldInterrupt = false
    var errorCounter = 0
    var maximumErrors = 10
    
    // MARK: Initial configuration
    func configure(){
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(userDidLogin),
                         name: .userDidLogin,
                         object: nil)
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(userDidLogout),
                         name: .userDidLogout,
                         object: nil)
        
        let syncNotificationNames: [Notification.Name] = [
            .databaseDidUpdate,
            UIApplication.didBecomeActiveNotification,
            .recordsDidRetrieve,
            .reachabilityChanged,
        ]
        
        syncNotificationNames.forEach { (name) in
            NotificationCenter
                .default
                .addObserver(self,
                    selector: #selector(syncingTriggered),
                    name: name,
                    object: nil)
        }
    }
    
    // MARK: ObjC Notification Center Selectors
    @objc func userDidLogin(_ sender: Any){
        guard let user = User.current else{
            return
        }
        
        shouldInterrupt = false
        
        do{
            try ArventaDB.shared.initializeUserDB()
        }catch{
            print(error)
        }
        //initial download process
        //check if user has logged in and downloaded before
        if let _ = LoginHistory.allHistory.first(where: {$0.userID == user.userID}){
            //proceed with just syncing
            self.startSyncing()
        }else{
            //download everything
            self.downloadAll()
        }
    }
    
    @objc func userDidLogout(_ sender: Any){
        //halt all processes
        shouldInterrupt = true
    }
    
    @objc func syncingTriggered(_ sender: Any){
        var modelType: AnyClass? = nil
        if let sender = sender as? NSNotification,
           let object = sender.object as? AnyClass{
            modelType = object
        }
        self.startSyncing(modelType: modelType)
    }
    
    // MARK: Initial Download Process
    func downloadAll(){
        guard let user = User.current else{
            return
        }
        // will download everything
        
        //after downloading, save it to history
        let history = LoginHistory(JSON: [:])
        history?.userID = user.userID
        history?.email = user.email
        history?.downloadedAt = Date()
        history?.saveToUserDefaults()
    }
    
    // MARK: Synchronization
    // NOTE: When triggering another sync after a sync, make sure to make "isSyncing" to false
    func startSyncing(modelType: AnyClass? = nil){
        guard let _ = User.current,
              !isSyncing, !ArventaWeb.shared.isOffline(),
              errorCounter < maximumErrors else{
            //will do nothing
            return
        }
        
        isSyncing = true
        print("Test run asynchronously")
        
        // start syncing products
        if self.didStartSyncingProducts(),
           modelType != nil || modelType == Product.self{
            // if syncing did start, it will stop the rest of the code blocks
            return
        }
        
        // start syncing storages
        // start syncing risks
        // etc. etc.
        
        
        print("Finished syncing")
        //after everything, attempt to update from the server
        updateFromServer()
    }
    
    // MARK: Retrieve updates from server
    func updateFromServer(modelType: AnyClass? = nil){
        isSyncing = false
        
        //proceed with updating from server
        if modelType != nil || modelType == Product.self{
            // download products
        }
    }
}
