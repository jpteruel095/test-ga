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
    
    var selectedApp: ArventaApp = .WHSMONITOR
    
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
        
        if signInTest(u: username, p: password) {
            return
        }
        
        self.showHUD()
        let request = SignInRequest(username: username, password: password, app: selectedApp)
        ArventaInterface.shared.signIn(request: request) { (token, error) in
            self.hideHUD()
            if let error = error{
                self.showErrorMessageAlert(error: error)
                return
            }
            //go to
            if token!.isMultifactorRequired{
                self.performSegue(withIdentifier: "showVerificationView", sender: sender)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension SignInViewController{
    func signInTest(u: String, p: String) -> Bool{
//        if u == "testaccount01" && p == "password123"{
//            User(JSON: [:])?.saveAsCurrentUser()
//            self.dismiss(animated: true, completion: nil)
//            return true
//        }else if u == "testaccount02" && p == "password123"{
//            self.performSegue(withIdentifier: "showVerificationView", sender: view)
//            return true
//        }
        return false
    }
}

extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
