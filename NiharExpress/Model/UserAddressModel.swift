//
//  UserAddressModel.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 27/09/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class UserAddressModel: Codable {
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var mobileNo: String
    
    init(name: String, address: String, latitude: Double, longitude: Double, mobileNo: String) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.mobileNo = mobileNo
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "address"
        case latitude = "lattitude"
        case longitude = "longitude"
        case mobileNo = "mobile_no"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        var name: String = (try? container.decode(String.self, forKey: .name)) ?? ""
        let address: String = (try? container.decode(String.self, forKey: .address)) ?? ""
        let latitude: Double = NSString(string: (try? container.decode(String.self, forKey: .latitude)) ?? "0").doubleValue
        let longitude: Double = NSString(string: (try? container.decode(String.self, forKey: .longitude)) ?? "0").doubleValue
        var mobileNo: String = (try? container.decode(String.self, forKey: .mobileNo)) ?? ""
        
        let charSet = CharacterSet(charactersIn: "[]")
        name = name.components(separatedBy: charSet).joined()
        mobileNo = mobileNo.components(separatedBy: charSet).joined()
        
        self.init(name: name, address: address, latitude: latitude, longitude: longitude, mobileNo: mobileNo)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.mobileNo, forKey: .mobileNo)
    }
}
