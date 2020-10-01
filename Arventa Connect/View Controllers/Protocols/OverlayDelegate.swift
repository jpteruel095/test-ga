//
//  OverlayDelegate.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import UIKit

protocol OverlayDelegate {
    
}

extension OverlayDelegate where Self: UIViewController{
    func showDarkOverlay(){
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.tag = 177013
        overlay.alpha = 0
        self.view.addSubview(overlay)
        
        UIView.animate(withDuration: 0.25) {
            overlay.alpha = 1
        }
    }

    func hideDarkOverlay(){
        guard let overlay = self.view.viewWithTag(177013) else{
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: {
                        overlay.alpha = 0
                       },
                       completion: { finished in
                        if finished{
                            overlay.removeFromSuperview()
                        }
                       })
    }
}
