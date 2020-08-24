//
//  DriverInfo.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/23/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class DriverInfo: Codable {
    var isPickUp: String
    var latitude: Double
    var longitude: Double
    var date: Date
    
    init(isPickUp: String, latitude: Double, longitude: Double, date: Date) {
        self.isPickUp = isPickUp
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
           case isPickUp = "is_pickup"
           case latitude = "latitude"
           case longitude = "longitude"
           case date = "date" /// 22-08-2020 04:21:09 pm
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isPickUp: String = try container.decode(String.self, forKey: .isPickUp)
        let latitude: Double = NSString(string: (try? container.decode(String.self, forKey: .latitude)) ?? "0").doubleValue
        let longitude: Double = NSString(string: (try? container.decode(String.self, forKey: .longitude)) ?? "0").doubleValue
        let dateStr: String = try container.decode(String.self, forKey: .date)
        let date: Date = dateStr.toDate(withFormat: "dd-MM-yyyy hh:mm:ss a")!
        
        self.init(isPickUp: isPickUp, latitude: latitude, longitude: longitude, date: date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.isPickUp, forKey: .isPickUp)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.date, forKey: .date)
    }
}
