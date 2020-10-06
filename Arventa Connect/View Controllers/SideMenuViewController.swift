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
    var iconname: String? { get }
}

extension MenuItemProtocol{
    var iconname: String?{
        return nil
    }
}

struct EncodedMenuItem: MenuItemProtocol{
    var id: Int
    var name: String
    var iconname: String?
}

class SideMenuViewController: UIViewController {
    @IBOutlet weak var closeButtonContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var initializeOnce = false
    var menuItems: [MenuItemProtocol] = []
    var selectedMenuItem: MenuItemProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeButtonContainerView.isHidden = UIDevice.is_iPad()
        menuItems = [EncodedMenuItem(id: 1, name: "Home", iconname: "icon-arventa-home")]
        
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
        ArventaInterface.shared.getMenuItems { (items, error) in
            self.menuItems.removeAll()
            if !items.contains(where: {$0.id == 1}){
                self.menuItems = [EncodedMenuItem(id: 1, name: "Home", iconname: "icon-arventa-home")]
            }
            self.menuItems.append(contentsOf: items)
            self.initializeOnce = true
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        if UIDevice.is_iPad(){
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        if UIDevice.is_iPad(){
            ArventaInterface.shared.signOut()
            return
        }
        
        self.dismiss(animated: true, completion: {
            ArventaInterface.shared.signOut()
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
        if let icon = item.iconname{
            cell.iconLabel.text = ArventaFontIcon.getUnicodeForIcon(named: icon)
        }
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
        
        if indexPath.row == 0 {
            MainNavigationController.current?.goToDashboardVC()
        }else{
            MainNavigationController.current?.goToTestProducts()
        }
        
        if UIDevice.is_iPhone(){
            self.dismiss(animated: true, completion: nil)
        }else if UIDevice.is_iPad(){
            tableView.reloadSections(IndexSet([indexPath.section]),
                                     with: .fade)
        }
    }
}

class SideMenuCell: UITableViewCell{
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
}
