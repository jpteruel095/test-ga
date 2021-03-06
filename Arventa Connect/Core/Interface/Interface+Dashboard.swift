//
//  Interface+Dashboard.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/29/20.
//

import Foundation

extension ArventaInterface{
    func getMenuItems(completion: @escaping([MenuItem], Error?) -> Void){
        completion(MenuItem.retrieveAll(), nil)
    }
}
