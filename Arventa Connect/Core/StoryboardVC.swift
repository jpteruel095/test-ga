//
//  StoryboardVC.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import UIKit

enum StoryboardVC: String{
    // MARK: List of storyboards used within the app
    case main
    
    // MARK: Temporary to avoid git conflicts
//    case temp
    /**
            When adding a new storyboard, I highly suggest using a single word and make it capitalized on the first letter.
     E.g., Main = case main
        Auth = case auth
     */
    
    // MARK: Getting the storyboard instance. It will throw a fatalError if the app doesn't find the storyboard file.
    var storyboard: UIStoryboard{
//        if self == .temp{
//            return UIStoryboard(name: "Temp-PAT", bundle: nil)
//        }
        return UIStoryboard(name: rawValue.capitalized, bundle: nil)
    }
        
    // MARK: Getting the initialViewController of the storyboard. It will throw a fatalError if the said storyboard doesn't have a view controller set as a the initial VC
    var initialViewController: UIViewController?{
        self.storyboard.instantiateInitialViewController()
    }
    
    // MARK: Getting a specific view controller using an identifier. It will throw a fatalError if the identifier doesn't exist inside the said storyboard. Better check the view controller's Storyboard ID inside the Identity Inspector
    func viewController(forIdentifier identifier: String) -> UIViewController?{
        storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
