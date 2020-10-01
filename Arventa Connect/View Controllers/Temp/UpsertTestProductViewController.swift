//
//  UpsertProductViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 10/1/20.
//

import UIKit

class UpsertTestProductViewController: UIViewController, ArventaViewDelegate {
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        guard let name = nameField.nullableTrimmmedText else{
            self.showInvalidInputMessageAlert(message: "Name must not be empty.")
            return
        }
        
        guard let product = Product(JSON: [:]) else{
            return
        }
        product.name = name
        
        ArventaInterface.shared.saveProduct(product) { (error) in
            if let error = error{
                self.showErrorMessageAlert(error: error)
                return
            }
            
            self.showMessageAlert(title: "Success", message: "Product has been saved."){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}
