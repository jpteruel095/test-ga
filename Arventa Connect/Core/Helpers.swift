//
//  Helpers.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import UIKit
import SwiftyJSON

struct Helpers{
    static func showMessageAlertView(viewController: UIViewController,
                                     title: String?,
                                     message: String?,
                                     actions: [UIAlertAction] = [],
                                     completion: (() -> Void)? = nil){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.count > 0{
            actions.forEach { (action) in
                alertView.addAction(action)
            }
        }else{
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let completion = completion {
                    completion()
                }
            }))
        }
        
        viewController.present(alertView, animated: true, completion: nil)
        
        var fullMessage = ""
        if let title = title{
            fullMessage += "\(title)\n"
        }
        if let message = message{
            fullMessage += message
        }
    }
    
    static func showActionSheet(viewController: UIViewController,
                                title: String?,
                                actions: [UIAlertAction],
                                popoverSourceView: UIView? = nil,
                                completion: (() -> Void)? = nil){
        let alertView = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        if actions.count > 0{
            actions.forEach { (action) in
                alertView.addAction(action)
            }
        }else{
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let completion = completion {
                    completion()
                }
            }))
        }
        
        if let sourceView = popoverSourceView ?? viewController.view{
            alertView.popoverPresentationController?.sourceView = sourceView
            alertView.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        
        viewController.present(alertView, animated: true, completion: nil)
    }
    
    static func makeError(with description: String, code: Int = 0) -> Error{
        NSError(domain: ArventaWeb.Constants.domainName,
                       code: code,
                       userInfo: [
                        NSLocalizedDescriptionKey: description
                       ])
    }
    
    static func makeOfflineError(code: Int = 0) -> Error{
        makeError(with: "You are currently offline.", code: code)
    }
    
    static func isOffline() -> Bool{
        guard let reachability = ArventaWeb.shared.reachability else{
            return false
        }
        return reachability.connection == .unavailable
    }
    
    static func sizeForItem(inCollectionView collectionView: UICollectionView, columns: CGFloat, defaultHeight: CGFloat) -> CGSize{

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let marginBetweenCells = flowLayout.minimumInteritemSpacing
            var totalMargin = (columns - 1) * marginBetweenCells
            totalMargin += flowLayout.sectionInset.left + flowLayout.sectionInset.right
            
            let totalSpaceLeft = collectionView.frame.width - totalMargin
            
            let cellWidth = totalSpaceLeft / columns
            return CGSize(width: cellWidth, height: defaultHeight)
        }else{
            let width = (UIScreen.main.bounds.width/columns) - (8+4)
            return CGSize(width: width, height: defaultHeight)
        }
    }
    
    static func loadJSONFromResource(named resourceName: String) -> JSON{
        guard let filePath = Bundle.main.url(forResource: resourceName, withExtension: "json"),
              let data = try? Data(contentsOf: filePath),
              let json = try? JSON(data: data) else {
            return JSON()
        }
        return json
    }
    
    static func loadJSONFromResourceAsync(named resourceName: String, completion: @escaping((JSON) -> Void)){
        DispatchQueue.global(qos: .background).async {
            guard let filePath = Bundle.main.url(forResource: resourceName, withExtension: "json"),
               let data = try? Data(contentsOf: filePath),
               let json = try? JSON(data: data) else {
                DispatchQueue.main.async {
                    completion(JSON())
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(json)
            }
        }
    }
}
