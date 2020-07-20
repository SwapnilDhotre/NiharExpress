//
//  Date_Extension.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 7/11/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
//        dateFormatter.locale = Locale(identifier: "fa-IR")
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension Date {

    func toString(withFormat format: String = "d MMM yyyy, h:mm a") -> String {

        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "fa-IR")
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
//        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
    
}
