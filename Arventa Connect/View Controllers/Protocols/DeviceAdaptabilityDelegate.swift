//
//  DeviceAdaptabilityDelegate.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/30/20.
//

import UIKit

protocol DeviceHeightAdaptabilityDelegate {
    func adjustForIphone11ProMax()
    func adjustForIphone11Pro()
    func adjustForIphone8Plus()
    func adjustForIphoneSE2()
    func adjustForIphoneSE()
    func adjustForIphone4s()
}

extension DeviceHeightAdaptabilityDelegate{
    func adaptToDeviceHeight(){
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight >= 896.0{
            adjustForIphone11ProMax()
        }
        else if screenHeight >= 812.0 && screenHeight < 896.0 {
            adjustForIphone11Pro()
        }
        else if screenHeight >= 736.0 && screenHeight < 812.0 {
            adjustForIphone8Plus()
        }
        else if screenHeight >= 667.0 && screenHeight < 736.0 {
            adjustForIphoneSE2()
        }
        else if screenHeight >= 568.0 && screenHeight < 667.0 {
            adjustForIphoneSE()
        }
        else if screenHeight < 568.0 {
            adjustForIphone4s()
        }
    }
}
