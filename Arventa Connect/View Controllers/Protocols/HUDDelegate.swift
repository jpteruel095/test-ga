//
//  HUDDelegate.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import Foundation
import MBProgressHUD

fileprivate class HUDWrapper{
    static var shared = HUDWrapper()
    
    var hud: MBProgressHUD?
}

protocol HUDDelegate: AnyObject {
    var refreshControl: UIRefreshControl? { get set }
}

extension HUDDelegate where Self: UIViewController{
    var refreshControl: UIRefreshControl?{
        get{
            return nil
        }
        set{
            
        }
    }
    
    var hud: MBProgressHUD?{
        get{
            return HUDWrapper.shared.hud
        }
        set{
            HUDWrapper.shared.hud = newValue
        }
    }
    
    func showHUD(withText text: String? = nil,
                 onView view: UIView? = nil,
                 withConfiguration configurationClosure: ((MBProgressHUD) -> Void)? = nil){
        if let view = view ?? self.view {
            //if there's an existing HUD, hide and unassign it first
            self.hideHUD()
            //create new HUD
            self.hud = MBProgressHUD.showAdded(to: view, animated: true)
            if let text = text{
                self.hud?.detailsLabel.text = text
            }
            
            configurationClosure?(self.hud!)
        }
    }
    
    func updateHUD(text: String){
        self.hud?.detailsLabel.text = text
    }
    
    func hideHUD(){
        self.hud?.hide(animated: true)
        self.hud = nil
        refreshControl?.endRefreshing()
    }
}
