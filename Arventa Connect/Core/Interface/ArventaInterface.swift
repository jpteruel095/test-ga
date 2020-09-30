//
//  ArventaInterface.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import UIKit
import SideMenu

class ArventaInterface{
    static var shared = ArventaInterface()
    
    var sideMenu: SideMenuManager = {
        let sideMenu = SideMenuManager.default
        guard let sideMenuVC = StoryboardVC.main.viewController(forIdentifier: "sideMenuVC") else{
            fatalError("Side Menu VC doesn't exist.")
        }
        
        let sideMenuNVC = SideMenuNavigationController(rootViewController: sideMenuVC)
        sideMenuNVC.menuWidth = UIScreen.main.bounds.width * 0.75
        sideMenuNVC.presentationStyle = .menuSlideIn
        sideMenu.leftMenuNavigationController = sideMenuNVC
        return sideMenu
    }()
    
    func configure(){
        let _ = ArventaDB.shared
        ArventaSync.shared.configure()
        let _ = ArventaWeb.shared
    }
    
    func signIn(request: SignInRequest, completion:@escaping((UserToken?, Error?) -> Void)){
        ArventaWeb.shared.signIn(request: request, completion: { token, error in
            if let error = error{
                completion(token, error)
                return
            }
            
            guard token?.isMultifactorRequired == false else{
                completion(token, error)
                return
            }
            
            ArventaWeb.shared.refreshUserDetails { (user, error) in
                completion(token, error)
            }
        })
    }
    
    func signOut(){
        UserDefaults.clearObject(forKey: .userObject)
        UserDefaults.clearObject(forKey: .accessToken)
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
}
