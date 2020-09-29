//
//  ArventaViewDelegate.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit

protocol ArventaViewDelegate {
    
}

// MARK: UI Alert Controller extensions
extension ArventaViewDelegate where Self: UIViewController{
    func showMessageAlert(title: String?,
                          message: String?,
                          actions: [UIAlertAction] = [],
                          completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: title,
                                     message: message,
                                     actions: actions,
                                     completion: completion)
    }
    
    func showErrorMessageAlert(message: String,
                               actions: [UIAlertAction] = [],
                               completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: "Error",
                                     message: message,
                                     actions: actions,
                                     completion: completion)
    }
    
    func showErrorMessageAlert(error: Error,
                               actions: [UIAlertAction] = [],
                               completion: (() -> Void)? = nil){
        self.showErrorMessageAlert(message: error.localizedDescription,
                                   actions: actions,
                                   completion: completion)
    }
    
    func willShowErrorMessageAlert(error: Error?,
                               actions: [UIAlertAction] = [],
                               completion: (() -> Void)? = nil) -> Bool{
        guard let error = error else{
            return false
        }
        self.showErrorMessageAlert(message: error.localizedDescription,
                                   actions: actions,
                                   completion: completion)
        return true
    }
    
    func showInvalidInputMessageAlert(message: String,
                                      actions: [UIAlertAction] = [],
                                      completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: "Invalid",
                                     message: message,
                                     actions: actions,
                                     completion: completion)
    }
    
    func showNoInternetConnectionMessageAlert(sender: UIViewController? = nil,
                                              actions: [UIAlertAction] = [],
                                              completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: "Error",
                                     message: "You appear to be offline.",
                                     actions: actions,
                                     completion: completion)
    }
    
    func showActionSheet(title: String?,
                         actions: [UIAlertAction],
                         popoverSourceView: UIView? = nil,
                         completion: (() -> Void)? = nil){
        Helpers.showActionSheet(viewController: self,
                                title: title,
                                actions: actions,
                                popoverSourceView: popoverSourceView,
                                completion: completion)
    }
    
    func makeError(with description: String, code: Int = 0) -> Error{
        return NSError(domain: ArventaWeb.Constants.domainName,
                       code: code,
                       userInfo: [
                        NSLocalizedDescriptionKey: description
                       ])
    }
    
    func willShowLogin() -> Bool{
        if User.current == nil,
           let signInNVC = StoryboardVC.main.viewController(forIdentifier: "signInNVC"){
            signInNVC.modalPresentationStyle = .fullScreen
            self.present(signInNVC, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    func willShowOfflineError() -> Bool{
        if ArventaWeb.shared.isOffline() {
            self.showErrorMessageAlert(error: Helpers.makeOfflineError())
            return true
        }
        
        return false
    }
    
    func present(viewController: UIViewController,
              inNavigation shouldShowInNavigation: Bool = false){
        if shouldShowInNavigation{
            let navVC = UINavigationController(rootViewController: viewController)
            navVC.modalPresentationStyle = .fullScreen
            navVC.navigationBar.barTintColor = .white
            self.present(navVC, animated: true, completion: nil)
        }else{
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
