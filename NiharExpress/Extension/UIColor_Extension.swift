//
//  UIColor_Extension.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 5/28/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        var hex = hex
        var alpha: Float = 100
        let hexLength = hex.count
        if !(hexLength == 7 || hexLength == 9) {
            // A hex must be either 7 or 9 characters (#RRGGBBAA)
            print("improper call to 'colorFromHex', hex length must be 7 or 9 chars (#GGRRBBAA)")
            self.init(white: 0, alpha: 1)
            return
        }

        if hexLength == 9 {
            // Note: this uses String subscripts as given below
            alpha = hex.substring(from: 1, to: 3).floatValue
            hex = hex.substring(from: 3, to: 8)
        }

        // Establishing the rgb color
        var rgb: UInt32 = 0
        let s: Scanner = Scanner(string: hex)
        // Setting the scan location to ignore the leading `#`
        s.scanLocation = 1
        // Scanning the int into the rgb colors
        s.scanHexInt32(&rgb)

        // Creating the UIColor from hex int
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha / 100)
        )
    }
}
