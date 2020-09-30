//
//  ArventaSync.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/24/20.
//

import UIKit
import Reachability

typealias SyncFunction = (() -> Void)
class SyncFunctionWrapper{
    var closure: SyncFunction
    
    init(_ closure: @escaping SyncFunction) {
        self.closure = closure
    }
}

class ArventaSync: NSObject{
    static var shared = ArventaSync()
    
    // MARK: App Syncing Variables
    var isSyncing = false
    var syncStack: [SyncFunctionWrapper] = []
    var shouldInterrupt = false
    
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
        self.startSyncing()
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
    func startSyncing(){
        guard let _ = User.current,
              !isSyncing, !ArventaWeb.shared.isOffline() else{
            //will not start if not logged in
            //will queue
            syncStack.append(SyncFunctionWrapper({
                self.startSyncing()
            }))
            return
        }
        
        isSyncing = true
        print("Test run asynchronously")
        
        //after everything, attempt to update from the server
        updateFromServer()
    }
    
    func updateFromServer(){
        if let wrapper = syncStack.first{
            //if there are stack of sync closures
            // will continue to call them
            // until they are all removed
            wrapper.closure()
            syncStack.removeAll(where: {$0 === wrapper})
            return
        }
        
        //proceed with updating from server
    }
}
