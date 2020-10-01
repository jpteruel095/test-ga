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
    var id: Int{ return menuId }
    var name: String{ return caption }
    var iconname: String? { return fontIconName }
    
    var menuId: Int = 1
    var caption: String = "N/A"
    var parentMenuId: Int?
    var menuLevel: Int = 1
    var access: AccessType = .FULL
    var fontIconName: String?
    var displayOrder: Int = 1
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        menuId <- map["menuId"]
        caption <- map["caption"]
        parentMenuId <- map["parentMenuId"]
        menuLevel <- map["menuLevel"]
        access <- map["access"]
        fontIconName <- map["fontIconName"]
        displayOrder <- map["displayOrder"]
    }
    
    func saveToCoreData(for user: User){
        let menuItem = MenuItemData(context: AppDelegate.shared.currentContext())
        menuItem.menuID = Int32(menuId)
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
