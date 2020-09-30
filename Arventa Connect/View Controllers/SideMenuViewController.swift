//
//  SideMenuViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import UIKit

protocol MenuItemProtocol {
    var id: Int { get }
    var name: String { get }
}

struct DemoMenuItem: MenuItemProtocol{
    var id: Int
    var name: String
}

class SideMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var initializeOnce = false
    var menuItems: [MenuItemProtocol] = []
    var selectedMenuItem: MenuItemProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuItems = [
            DemoMenuItem(id: 1, name: "Home"),
        ]
        
        selectedMenuItem = menuItems.first
        
        //add listener
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMenuItems), name: .menuItemsDidUpdate, object: nil)
        
        if !initializeOnce {
            self.refreshMenuItems(self)
            initializeOnce = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func refreshMenuItems(_ sender: Any){
        ArventaInterface.shared.getMenuItems { (items) in
            self.menuItems = items
            self.initializeOnce = true
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            ArventaInterface.shared
                .signOut()
        })
    }
}

extension SideMenuViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! SideMenuCell
        let item = menuItems[indexPath.row]
        
        //configure texts
        cell.titleLabel.text = item.name
        
        //update background color
        if item.id == selectedMenuItem?.id{
            cell.backgroundColor = UIColor(hexString: "ECEEEF").withAlphaComponent(0.15)
        }else{
            cell.backgroundColor = .none
        }
        
        return cell
    }
}

extension SideMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        self.selectedMenuItem = item

        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

class SideMenuCell: UITableViewCell{
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
