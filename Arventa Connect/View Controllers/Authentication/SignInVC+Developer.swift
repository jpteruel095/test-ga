//
//  SignInVC+Developer.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import UIKit

// This protocol will only take effect if the app is in debug mode
#if DEBUG
extension SignInViewController{
    struct Account{
        var username: String
        var password: String
        var app: ArventaApp
        
        func selectionLabel() -> String{
            return "\(username) (\(app.labelText))"
        }
    }
    
    func shakeAction(){
        var actions: [UIAlertAction] = []
        
        actions.append(UIAlertAction(title: "Autofill Credentials",
                                            style: .default, handler: { (action) in
                                                self.autofillCredentials(accountType: .siteAccount)
        }))
        
        actions.append(UIAlertAction(title: "Autofill Credentials (with Mobile Verification)",
                                            style: .default, handler: { (action) in
                                                self.autofillCredentials(accountType: .siteAccountMobileVerification)
        }))
        
        actions.append(UIAlertAction(title: "Autofill Credentials (Auditor accounts)",
                                            style: .default, handler: { (action) in
                                                self.autofillCredentials(accountType: .auditor)
        }))
        
        actions.append(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        self.showActionSheet(title: "Select Action",
                             actions: actions,
                             popoverSourceView: self.appDropdownLabel)
    }
    
    enum AccountType: String{
        case siteAccount = "Site Account"
        case siteAccountMobileVerification = "Site Account with Mobile Verification"
        case auditor = "Auditor"
        case auditorMobileVerification = "Auditor with Mobile Verification"
    }
    
    func autofillCredentials(accountType: AccountType){
        var accounts: [Account] = []
        if accountType == .siteAccount{
            accounts = [
                Account(username: "cc_numlock",
                        password: "mAnilA~18",
                        app: .CHEMICALCADDY),
                Account(username: "fm_numlock",
                        password: "mAnilA~18",
                        app: .FARMMINDER),
                Account(username: "msds_numlock",
                        password: "mAnilA~18",
                        app: .MSDS),
                Account(username: "pg_numlock",
                        password: "mAnilA~18",
                        app: .PESTGENIE),
                Account(username: "sm_numlock",
                        password: "mAnilA~18",
                        app: .STOREMANIFEST),
                Account(username: "whsrogomi",
                        password: "mAnilA~18",
                        app: .WHSMONITOR),
                
                Account(username: "cc_rogomi",
                        password: "watsoN#12345",
                        app: .CHEMICALCADDY),
                Account(username: "fm_rogomi",
                        password: "watsoN#12345",
                        app: .FARMMINDER),
                Account(username: "msds_rogomi",
                        password: "watsoN#12345",
                        app: .MSDS),
                Account(username: "pg_rogomi",
                        password: "watsoN#12345",
                        app: .PESTGENIE),
                Account(username: "sm_rogomi",
                        password: "watsoN#12345",
                        app: .STOREMANIFEST),
                Account(username: "whs_numlock",
                        password: "watsoN#12345",
                        app: .WHSMONITOR),
            ]
        }else if accountType == .siteAccountMobileVerification{
            accounts = [
                Account(username: "cc_numlock1",
                        password: "watsoN#12345",
                        app: .CHEMICALCADDY),
                Account(username: "fm_numlock1",
                        password: "watsoN#12345",
                        app: .FARMMINDER),
                Account(username: "msds_numlock1",
                        password: "watsoN#12345",
                        app: .MSDS),
                Account(username: "pg_numlock1",
                        password: "watsoN#12345",
                        app: .PESTGENIE),
                Account(username: "sm_numlock1",
                        password: "watsoN#12345",
                        app: .STOREMANIFEST),
                Account(username: "whsrogomi1",
                        password: "watsoN#12345",
                        app: .WHSMONITOR),
            ]
        }else if accountType == .auditor{
            accounts = [
                Account(username: "chemauditor1",
                        password: "whsuseR~293",
                        app: .WHSMONITOR),
                Account(username: "cc_auditor",
                        password: "watsoN#12345",
                        app: .CHEMICALCADDY),
                Account(username: "fm_auditor",
                        password: "watsoN#12345",
                        app: .FARMMINDER),
                Account(username: "msds_auditor",
                        password: "watsoN#12345",
                        app: .MSDS),
                Account(username: "pg_auditor",
                        password: "watsoN#12345",
                        app: .CHEMICALCADDY),
                Account(username: "sm_auditor",
                        password: "watsoN#12345",
                        app: .STOREMANIFEST),
                Account(username: "whs_rogomiauditor",
                        password: "watsoN#12345",
                        app: .WHSMONITOR),
            ]
        }else if accountType == .auditorMobileVerification{
            accounts = [
            ]
        }
        
        var actions = accounts.map{ account in
            UIAlertAction(title: account.selectionLabel(),
                          style: .default) { (action) in
                self.usernameField.text = account.username
                self.passwordField.text = account.password
                self.selectedApp = account.app
                self.appDropdownLabel.text = account.app.labelText
            }
        }
        actions.append(.cancelButton())
        self.showActionSheet(title: "Select Account (\(accountType.rawValue))",
                             actions: actions,
                             popoverSourceView: self.appDropdownLabel)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       if motion == .motionShake {
           self.shakeAction()
       }
    }
}
#endif
