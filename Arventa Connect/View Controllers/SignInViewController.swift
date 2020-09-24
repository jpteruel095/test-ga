//
//  SignInViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit
import JVFloatLabeledTextField

class SignInViewController: UIViewController, ArventaViewDelegate, HUDDelegate {
    @IBOutlet weak var usernameField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let username = usernameField.nullableTrimmmedText else{
            self.showInvalidInputMessageAlert(message: "Username must not be empty.")
            return
        }
        
        guard let password = passwordField.nullableTrimmmedText else{
            self.showInvalidInputMessageAlert(message: "Password must not be empty.")
            return
        }
        
//        self.showHUD()
//        ArventaWeb.shared.getSomething
        self.performSegue(withIdentifier: "showVerificationView", sender: sender)
    }
}

extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
