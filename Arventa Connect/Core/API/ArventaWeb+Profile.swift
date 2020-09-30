//
//  ArventaWeb+Profile.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/30/20.
//

import Foundation

extension ArventaWeb{
    func refreshUserDetails(completion: @escaping((Error?) -> Void)){
        Endpoint.useridentity.request(completion: { (json, error) in
            if let error = error{
                completion(error)
                return
            }
            
            guard let jsonString = json?.rawString(),
                let user = User(JSONString: jsonString) else{
                completion(Helpers.makeError(with: "Could not retrieve user identity."))
                return
            }
            
            user.saveAsCurrentUser()
            completion(nil)
        })
    }
    
    func getMenuItems(completion: @escaping((Error?) -> Void)){
        guard let user = User.current else{
            return
        }
        
        Endpoint.menuasync.request(completion: { (json, error) in
            if let error = error{
                completion(error)
                return
            }
            
            guard let items = json?.array else{
                completion(nil)
                return
            }
            
            let menuItems = items.compactMap { (json) -> MenuItem? in
                guard let dict = json.dictionaryObject else{
                    return nil
                }
                return MenuItem(JSON: dict)
            }
            
            MenuItem.deleteAll()
            menuItems.forEach { (menuItem) in
                menuItem.saveToCoreData(for: user)
            }
            
            //after saving, send notice
            NotificationCenter.default.post(name: .menuItemsDidUpdate, object: nil)
            
            completion(nil)
        })
    }
}
