//
//  SignInViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var usernameField: FloatingPlaceholderField!
    @IBOutlet weak var passwordField: FloatingPlaceholderField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension SignInViewController: FloatingPlaceholderFieldDelegate{
    func fieldEditingChanged(_ field: FloatingPlaceholderField) {
        
    }
    func fieldShouldReturn(_ field: FloatingPlaceholderField) -> Bool {
        field.textField.resignFirstResponder()
        return true
    }
}
