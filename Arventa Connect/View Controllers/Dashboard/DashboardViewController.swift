//
//  LandingViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit
import SideMenu
import SwiftDate
import SwiftyJSON

class DashboardViewController: UIViewController, ArventaViewDelegate {
    static var shared: DashboardViewController?
    
    @IBOutlet weak var greetingIconImageView: UIImageView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DashboardViewController.shared = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ArventaInterface.shared.getProducts { (products, error) in
            if let error = error{
                self.showErrorMessageAlert(error: error)
                return
            }
            
            guard let products = products else{
                self.showErrorMessageAlert(message: "No products")
                return
            }
            
            print("Products: ", JSON(products))
        }
    }

    @IBAction func didTapSideMenuButton(_ sender: Any) {
        guard let sideMenuNVC = ArventaInterface.shared.sideMenu.leftMenuNavigationController else{
            return
        }
        self.present(sideMenuNVC, animated: true, completion: nil)
    }
}

extension DashboardViewController{
    func refreshView(){
        guard let fullName = User.current?.fullName else{
            return
        }
        
        let greeting = getCurrentGreeting()
        greetingLabel.text = """
        \(greeting),
        \(fullName)
        """
    }
    
    func getCurrentGreeting() -> String{
        let region = Region.init(calendar: Calendars.gregorian, zone: Zones.asiaManila, locale: Locales.english)
        let date = Date().convertTo(region: region)
        guard let midnight = date.dateBySet(hour: 0, min: 0, secs: 0),
            let noon = date.dateBySet(hour: 12, min: 0, secs: 0),
            let evening = date.dateBySet(hour: 18, min: 0, secs: 0) else{
            return "Guten Morgen"
        }
        
        let now = Date().convertTo(region: region)
        if now.isInRange(date: midnight, and: noon){
            self.greetingIconImageView.image = UIImage(named: "greetings/morning")
            return "Good morning"
        }else if now.isInRange(date: noon, and: evening){
            self.greetingIconImageView.image = UIImage(named: "greetings/afternoon")
            return "Good afternoon"
        }else{
            self.greetingIconImageView.image = UIImage(named: "greetings/evening")
            return "Good evening"
        }
    }
}
extension DashboardViewController: SideMenuNavigationControllerDelegate, OverlayDelegate{
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        self.showDarkOverlay()
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        self.hideDarkOverlay()
    }
}
