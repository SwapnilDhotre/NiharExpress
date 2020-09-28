//
//  Util.swift
//  Nihar
//
//  Created by Swapnil Dhotre on 24/05/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class Util {
    
    static func setIntialController(window: UIWindow) {
        
        window.rootViewController = UINavigationController(rootViewController: PickUpAddressViewController())
        window.makeKeyAndVisible()
    }
    
    static func isBackPressed(string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(char, "\u{8}"))
        if isBackSpace == -8 {
            return true
        } else {
            return false
        }
    }
}
