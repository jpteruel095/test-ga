//
//  SideMenuViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import UIKit

class SideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        ArventaInterface.shared
            .signOut()
        ArventaInterface.shared
            .sideMenu
            .leftMenuNavigationController?
            .dismiss(animated: true, completion: {
                LandingViewController.shared?.userDidLogout(self)
            })
    }
}
