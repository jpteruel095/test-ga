//
//  LoginHistory.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import ObjectMapper

class LoginHistory: Mappable{
    static var allHistory: [LoginHistory]{
        let rawHistory = UserDefaults.getObject(forKey: .loginHistory) as? [Any]
        var history = rawHistory?.compactMap({ anyVal -> LoginHistory? in
            guard let json = anyVal as? [String: Any] else{
                return nil
            }
            return LoginHistory(JSON: json)
        })
        
        if history == nil{
            history = []
        }
        
        return history ?? []
    }
    var userID: String?
    var email: String?
    var downloadedAt: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userID <- map["userID"]
        email <- map["email"]
        downloadedAt <- map["downloadedAt"]
    }
    
    func saveToUserDefaults(){
        var history = LoginHistory.allHistory
        if let existing = history.first(where: {$0.userID == self.userID}){
            history.removeAll(where: {$0 === existing})
        }
        history.append(self)
        UserDefaults.storeObject(history.map{$0.toJSON()},
                                 forKey: .loginHistory)
    }
    
    func removeFromUserDefaults(){
        var history = LoginHistory.allHistory
        history.removeAll(where: {$0.userID == self.userID})
        UserDefaults.storeObject(history.map{$0.toJSON()},
                                 forKey: .loginHistory)
    }
}

