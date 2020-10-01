//
//  TestProductsViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import UIKit

class TestProductsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(databaseDidSync(_:)), name: .databaseDidSync, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ArventaInterface.shared.getProducts { (products, error) in
            self.products = products
            self.tableView.reloadData()
        }
    }
    
    @objc func databaseDidSync(_ sender: Any){
        print("Records synced, refreshed table")
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
        let product = products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell")!
        if let label = cell.viewWithTag(1000) as? UILabel{
            guard let name = product.name else{
                label.text = String(format: "%d", indexPath.row + 1)
                return cell
            }
            
            let synced = !product.isSyncable ? " (Synced)" : ""
            label.text = String(format: "%d: %@%@", product.id, name, synced)
        }
        return cell
    }
}
