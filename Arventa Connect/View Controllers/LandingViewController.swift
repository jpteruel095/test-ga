//
//  LandingViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit
import SideMenu

class LandingViewController: UIViewController, ArventaViewDelegate {
    static var shared: LandingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ArventaInterface
            .shared
            .sideMenu
            .addScreenEdgePanGesturesToPresent(toView: view,
                                               forMenu: .left)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout(_:)), name: .userDidLogout, object: nil)
        LandingViewController.shared = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if willShowLogin(){
            return
        }
    }
    
    @objc func userDidLogout(_ sender: Any){
        let _ = willShowLogin()
    }

    @IBAction func didTapSideMenuButton(_ sender: Any) {
        guard let sideMenuNVC = ArventaInterface.shared.sideMenu.leftMenuNavigationController else{
            return
        }
        self.present(sideMenuNVC, animated: true, completion: nil)
    }
}

extension LandingViewController: SideMenuNavigationControllerDelegate, OverlayDelegate{
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        self.showDarkOverlay()
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        self.hideDarkOverlay()
    }
}
