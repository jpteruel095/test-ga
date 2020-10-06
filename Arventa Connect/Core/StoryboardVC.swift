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
    case main_ipad = "Main-iPad"
    case auth
    case dashboard
    case temp
    
    var isManuallyEncoded: Bool{
        let manual: [StoryboardVC] = [
            .main_ipad
        ]
        return manual.contains(self)
    }
    
    // MARK: Getting the storyboard instance. It will throw a fatalError if the app doesn't find the storyboard file.
    var storyboard: UIStoryboard{
        if self.isManuallyEncoded{
            return UIStoryboard(name: rawValue, bundle: nil)
        }
        return UIStoryboard(name: rawValue.capitalized, bundle: nil)
    }
        
    // MARK: Getting the initialViewController of the storyboard. It will throw a fatalError if the said storyboard doesn't have a view controller set as a the initial VC
    var initialViewController: UIViewController?{
        self.storyboard.instantiateInitialViewController()
    }
    
    // MARK: Getting a specific view controller using an identifier. It will throw a fatalError if the identifier doesn't exist inside the said storyboard. Better check the view controller's Storyboard ID inside the Identity Inspector
    func viewController(withId identifier: String) -> UIViewController?{
        storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
