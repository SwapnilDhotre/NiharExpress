//
//  String_extension.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 5/28/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

extension String {

    /**
    Returns the float value of a string
    */
    var floatValue: Float {
        return (self as NSString).floatValue
    }

    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }

    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}

/// Validation
extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   var isValidPhone: Bool {
      let PHONE_REGEX = "^[7-9][0-9]{9}$";
      let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
      return phoneTest.evaluate(with: self)
   }
}

// Size of string
extension String {
    func titleWidth(attributes: [NSAttributedString.Key : Any]? = nil) -> CGFloat {
        return self.size(withAttributes: attributes).width + 40
    }
}
