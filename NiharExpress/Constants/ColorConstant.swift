//
//  ColorConstant.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

enum ColorConstant: String {
    case themePrimary = "#801e75"
    case appBlackLabel = "#4C4C4C"
    
    var color: UIColor {
        return UIColor(hex: self.rawValue)
    }
}
