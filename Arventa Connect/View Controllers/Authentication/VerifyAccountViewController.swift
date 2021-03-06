//
//  VerifyAccountViewController.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/28/20.
//

import UIKit
import IBAnimatable

class VerifyAccountViewController: UIViewController, ArventaViewDelegate, HUDDelegate {
    @IBOutlet weak var codeSentLabel: UILabel!
    @IBOutlet weak var otpFieldsStackView: UIStackView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var continueButton: AnimatableButton!
    
    let blockedCharacters = CharacterSet.alphanumerics.inverted
    var otpFields: [AnimatableTextField]{
        otpFieldsStackView.arrangedSubviews.compactMap({$0 as? AnimatableTextField})
    }
    
    var userToken: UserToken?
    var resendRequest: SignInRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toggleContinueButton()
        for i in 0...otpFields.count - 1{
            let field = otpFields[i]
            field.tag = 1000 + i
            field.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
            field.delegate = self
        }
        otpFields.first?.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let mobile = userToken?.mobile else{
            return
        }
        codeSentLabel.text = "Code is sent to \(mobile)"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResendButton(_ sender: Any) {
        guard let request = self.resendRequest else{
            return
        }
        
        self.showHUD()
        ArventaInterface.shared.signIn(request: request) { (token, error) in
            self.hideHUD()
            if let error = error{
                if error.getCode() == 500{
                    self.showInvalidInputMessageAlert(message: error.localizedDescription)
                }else{
                    self.showErrorMessageAlert(message: error.localizedDescription)
                }
                return
            }
            
            guard let token = token else {
                self.showErrorMessageAlert(message: "Invalid Token Returned")
                return
            }

            self.userToken = token
            self.showMessageAlert(title: "Success", message: "The code has been sent.")
        }
    }
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        guard let code = userToken?.code,
              getOTP().count == 6 else{
            return
        }
        
        self.showHUD()
        let request = VerificationRequest(code: code,
                                          securityCode: getOTP())
        ArventaInterface.shared.verify(request: request) { (token, error) in
            self.hideHUD()
            
            if let error = error{
                self.showErrorMessageAlert(error: error)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension VerifyAccountViewController{
    func toggleContinueButton(){
        if getOTP().count == 6{
            continueButton.isEnabled = true
            continueButton.backgroundColor = UIColor(hexString: "5FA8DC")
            continueButton.setTitleColor(.white, for: .normal)
        }else{
            continueButton.isEnabled = false
            continueButton.backgroundColor = UIColor(hexString: "DEE1E4")
            continueButton.setTitleColor(UIColor(hexString: "3F445A").withAlphaComponent(0.6), for: .normal)
        }
    }
}

extension VerifyAccountViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? AnimatableTextField{
            field.borderColor = UIColor(hexString: "5FA8DC")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.rangeOfCharacter(from: blockedCharacters) == nil else{
            return false
        }
        if textField.trimmedText.count == 1{
            if string.count > 0{
                textField.text = String(string[string.count - 1])
                self.textFieldEditingChanged(textField)
                return false
            }
        }
        return true
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField){
        if textField.trimmedText.count == 1{
            //skip to next
            if let nextField = otpFieldsStackView.viewWithTag(textField.tag + 1) as? UITextField{
                nextField.becomeFirstResponder()
            }
        }
        toggleContinueButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? AnimatableTextField{
            field.borderColor = field.trimmedText.count > 0 ? UIColor(hexString: "5FA8DC") : UIColor(hexString: "BFC4CA")
        }
    }
    
    func getOTP() -> String{
        return otpFields.map{$0.trimmedText}.joined()
    }
}
