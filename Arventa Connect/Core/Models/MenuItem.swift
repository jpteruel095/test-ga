//
//  MenuItem.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/30/20.
//

import ObjectMapper
import CoreData

enum AccessType: String{
    case FULL
    case READONLY
    case NOACCESS
}
class MenuItem: Mappable, MenuItemProtocol{
    var id: Int{ return menuID }
    var name: String{ return caption }
    
    var menuID: Int = 1
    var caption: String = "N/A"
    var parentID: Int?
    var menuLevel: Int = 1
    var access: AccessType = .FULL
    var actionName: String?
    var displayOrder: Int = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        menuID <- map["menuId"]
        caption <- map["caption"]
        parentID <- map["parentMenuId"]
        menuLevel <- map["menuLevel"]
        access <- map["access"]
        actionName <- map["actionName"]
        displayOrder <- map["displayOrder"]
    }
    
    func saveToCoreData(for user: User){
        let menuItem = MenuItemData(context: AppDelegate.shared.currentContext())
        menuItem.menuID = Int32(menuID)
        menuItem.json = self.toJSONString()
        AppDelegate.shared.saveContext()
    }
}

extension MenuItem{
    static func retrieveAll() -> [MenuItem]{
        let managedContext = AppDelegate.shared.currentContext()
        do {
            let rawItems = try managedContext.fetch(MenuItemData.fetchRequest())
            let menuItems = rawItems.compactMap { (item) -> MenuItem? in
                guard let item = item as? MenuItemData,
                      let json = item.json else{
                    return nil
                }
                
                return MenuItem(JSONString: json)
            }
            return menuItems.sorted(by: {
                $0.displayOrder < $1.displayOrder
            })
        } catch let error as NSError {
            print("Could not fetch. \(error)")
            return []
        }
    }
    
    static func deleteAll(){
        let managedContext = AppDelegate.shared.currentContext()
        do {
            let rawItems = try managedContext.fetch(MenuItemData.fetchRequest())
            rawItems.forEach { (item) in
                guard let object = item as? NSManagedObject else{
                    return
                }
                AppDelegate.shared.currentContext().delete(object)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        AppDelegate.shared.saveContext()
        NotificationCenter.default.post(name: .menuItemsDidUpdate, object: nil)
    }
}
