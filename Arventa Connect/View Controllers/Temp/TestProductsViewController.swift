//
//  TestProductsViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import UIKit

class TestProductsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var products: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ArventaInterface.shared.getProducts { (products, error) in
            self.products = products
            self.tableView.reloadData()
        }
    }

}

extension TestProductsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell")!
        if let label = cell.viewWithTag(1000) as? UILabel{
            guard let name = products[indexPath.row]["name"] as? String else{
                label.text = String(format: "%d", indexPath.row + 1)
                return cell
            }
            
            label.text = String(format: "%d: %@", indexPath.row + 1, name)
        }
        return cell
    }
}
