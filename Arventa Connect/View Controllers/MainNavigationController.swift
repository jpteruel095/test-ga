//
//  MainNavigationController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import UIKit

class MainNavigationController: UINavigationController, ArventaViewDelegate{
    static var current: MainNavigationController?
    
    var didStartUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainNavigationController.current = self
        
        if UIDevice.is_iPhone(){
            ArventaInterface
                .shared
                .sideMenu
                .addScreenEdgePanGesturesToPresent(toView: view,
                                                   forMenu: .left)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin(_:)), name: .userDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout(_:)), name: .userDidLogout, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if willShowLogin(){
            didStartUp = true
            return
        }
        
        if !didStartUp{
            goToDashboardVC()
            didStartUp = true
        }
    }
    
    @objc func userDidLogin(_ sender: Any){
        goToDashboardVC()
    }
    
    @objc func userDidLogout(_ sender: Any){
        goToBlankVC()
        let _ = willShowLogin()
    }
}

extension MainNavigationController{
    func goToBlankVC(){
        if let blankVC = StoryboardVC.main.viewController(withId: "blankVC"){
            self.setViewControllers([blankVC], animated: false)
            self.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func goToDashboardVC(){
        if let dashboardVC = StoryboardVC.dashboard.viewController(withId: "dashboardVC") as? DashboardViewController{
            self.setViewControllers([dashboardVC], animated: false)
            self.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func goToTestProducts(){
        if let testProductVC = StoryboardVC.temp.viewController(withId: "testProductsVC") as? TestProductsViewController{
            self.setViewControllers([testProductVC], animated: false)
            self.setNavigationBarHidden(false, animated: false)
        }
    }
}
