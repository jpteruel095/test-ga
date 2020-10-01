//
//  SignInViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit
import JVFloatLabeledTextField

class SignInViewController: UIViewController, ArventaViewDelegate, HUDDelegate {
    @IBOutlet weak var appDropdownLabel: UILabel!
    @IBOutlet weak var usernameField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordField: JVFloatLabeledTextField!
    
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    var selectedApp: ArventaApp = .WHSMONITOR
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appDropdownLabel.text = selectedApp.labelText
        self.adaptToDeviceHeight()
    }
    
    @IBAction func didTapAppDropdown(_ sender: Any) {
        var actions = ArventaApp.allCases.map({ app in
            UIAlertAction(title: app.labelText, style: .default) { (action) in
                self.selectedApp = app
                self.appDropdownLabel.text = app.labelText
            }
        })
        actions.append(.cancelButton())
        self.showActionSheet(title: "Which app would you like to log into?",
                             actions: actions,
                             popoverSourceView: self.appDropdownLabel)
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
            guard let token = token else{
                self.showErrorMessageAlert(message: "Impossible...")
                return
            }
            
            if token.isMultifactorRequired{
                if let verifyAccountVC = StoryboardVC.auth.viewController(forIdentifier: "verifyAccountVC") as? VerifyAccountViewController{
                    verifyAccountVC.userToken = token
                    verifyAccountVC.resendRequest = request
                    self.show(verifyAccountVC, sender: sender)
                }
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

extension SignInViewController: DeviceHeightAdaptabilityDelegate{
    func adjustForIphone11ProMax() {
        //ignore, remain as is
        logoTopConstraint.constant = 100
        loginButtonTopConstraint.constant = 175
        loginButtonBottomConstraint.constant = 75
    }
    
    func adjustForIphone11Pro() {
        logoTopConstraint.constant = 100
        loginButtonTopConstraint.constant = 120
        loginButtonBottomConstraint.constant = 20
    }
    
    func adjustForIphone8Plus() {
        logoTopConstraint.constant = 80
        loginButtonTopConstraint.constant = 110
        loginButtonBottomConstraint.constant = 20
    }
    
    func adjustForIphoneSE2() {
        logoTopConstraint.constant = 20
        loginButtonTopConstraint.constant = 40
        loginButtonBottomConstraint.constant = 20
    }
    
    func adjustForIphoneSE() {
        logoTopConstraint.constant = 20
        loginButtonTopConstraint.constant = 0
        loginButtonBottomConstraint.constant = 20
    }
    
    func adjustForIphone4s() {
        logoTopConstraint.constant = 0
        loginButtonTopConstraint.constant = 0
        loginButtonBottomConstraint.constant = 20
    }
    
    
}

extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
