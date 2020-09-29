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

}

class SideMenuTableViewController: UITableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
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
}
