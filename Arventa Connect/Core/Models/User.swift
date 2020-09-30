//
//  User.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import ObjectMapper
import SwiftyJSON

class User: Mappable{
    static var current: User?{
        if let userDict = UserDefaults.getObject(forKey: .userObject) as? [String: Any],
            let user = User(JSONString: userDict.toJSONString()){
            return user
        }
        return nil
    }
    
    var userID: String!
    var memberID: Int = 0
    var fullName: String!
    var email: String!
    var mobile: String?
    
    var userName: String!
    var applicationName: String!
    var applicationID: String!
    
    var subscriptionType: String?
    var subscriptionTypeID: Int?
    var scope: String?
    
    func saveAsCurrentUser(){
        let user = self.toJSON()
        UserDefaults.storeObject(user, forKey: .userObject)
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        memberID <- map["memberId"]
        fullName <- map["fullName"]
        email <- map["email"]
        mobile <- map["mobile"]
        userID <- map["userId"]
        userName <- map["userName"]
        applicationName <- map["applicationName"]
        applicationID <- map["applicationId"]
        subscriptionType <- map["subscriptionType"]
        subscriptionTypeID <- map["subscriptionTypeId"]
        scope <- map["scope"]
    }
    
    static func clearUserObject(){
        //a logout method
        UserDefaults.clearObject(forKey: .userObject)
    }
    
    enum AccountSubscriptionType { case auditor; case siteaccount; }
    func accountSubscriptionType() -> AccountSubscriptionType{
        if self.subscriptionTypeID == 96{
            return .auditor
        }else{
            return .siteaccount
        }
    }
    
    func isAuditor() -> Bool{
        return self.accountSubscriptionType() == .auditor
    }
}

class UserToken: Mappable{
    static var current: UserToken?{
        if let tokenDict = UserDefaults.getObject(forKey: .accessToken) as? [String: Any],
            let token = UserToken(JSONString: tokenDict.toJSONString()){
            return token
        }
        return nil
    }
    
    var accessToken: String!
    var accessTokenExpiration: Date!
    
    var refreshToken: String?
    var refreshTokenTokenExpiration: Date?
    
    var tokenType: String?
    var isMultifactorRequired: Bool = true
    
    //for multifactor
    var code: String?
    var fullName: String?
    var mobile: String?
    var metadata: String?
    
    func saveToken(){
        UserDefaults.storeObject(self.toJSON(), forKey: .accessToken)
    }
    
    // Object Mapper Functions
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        accessToken <- map["accessToken"]
        accessTokenExpiration <- (map["accessTokenExpiratation"], DateTransform())
        refreshToken <- map["refreshToken"]
        refreshTokenTokenExpiration <- (map["refreshTokenTokenExpiratation"], CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        tokenType <- map["tokenType"]
        isMultifactorRequired <- map["isMultifactorRequired"]
        
        code <- map["code"]
        metadata <- map["metadata"]
        mobile <- map["mobile"]
        fullName <- map["fullName"]
    }
    
    static func clearAccessToken(){
        //a logout method
        UserDefaults.clearObject(forKey: .accessToken)
    }
    
    func accessTokenExpired() -> Bool{
        self.accessTokenExpiration.compare(Date().addingTimeInterval(-60)) == .orderedAscending
    }
    
    func refreshTokenExpired() -> Bool{
        self.refreshTokenTokenExpiration?.compare(Date()) == .orderedAscending
    }
}
