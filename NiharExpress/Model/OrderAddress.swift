//
//  OrderAddress.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

func ==(lhs: OrderAddress, rhs: OrderAddress) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

enum OrderStatusType {
    case pickUp
    case delivery
}

class OrderAddress: Codable {
    var userName: String
    var mobileNo: String
    var addressId: String
    var address: String
    var lat: String
    var long: String
    var time: String
    var isComplete: String
    var storeName: String?
    var storeContactNo: String?
    var orderType: String?
    var transactionType: String?
    var completedDate: Date?
    
    var orderStatusType: OrderStatusType = .pickUp // Only local use
    
    var isFirstCell: Bool = false // Only local use
    var isLastCell: Bool = false // Only local use
    
    init(userName: String, mobileNo: String, addressId: String, address: String, lat: String, long: String, time: String, isComplete: String) {
        self.userName = userName
        self.mobileNo = mobileNo
        self.addressId = addressId
        self.address = address
        self.lat = lat
        self.long = long
        self.time = time
        self.isComplete = isComplete
    }
    
    enum CodingKeys: String, CodingKey {
        case userName = "name"
        case mobileNo = "mobile_no"
        case addressId = "address_id"
        case address = "address"
        case lat = "lattitude"
        case long = "longitude"
        case time = "time"
        case isComplete = "is_complete"
        case storeName = "shop_name"
        case storeContactNo = "store_contact_no"
        case orderType = "order_type"
        case transactionType = "transaction_type"
        case completedDate = "completed_date"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let userName = try container.decode(String.self, forKey: .userName)
        let mobileNo = try container.decode(String.self, forKey: .mobileNo)
        let addressId = try container.decode(String.self, forKey: .addressId)
        let address = try container.decode(String.self, forKey: .address)
        let lat = try container.decode(String.self, forKey: .lat)
        let long = try container.decode(String.self, forKey: .long)
        let time = try container.decode(String.self, forKey: .time)
        let isComplete = try container.decode(String.self, forKey: .isComplete)
        
        self.init(userName: userName, mobileNo: mobileNo, addressId: addressId, address: address, lat: lat, long: long, time: time, isComplete: isComplete)
        
        self.storeName = try? container.decode(String.self, forKey: .storeName)
        self.storeContactNo = try? container.decode(String.self, forKey: .storeContactNo)
        self.orderType = try? container.decode(String.self, forKey: .orderType)
        self.transactionType = try? container.decode(String.self, forKey: .transactionType)
        
        let completedDateString = try? container.decode(String.self, forKey: .completedDate)
        if let str = completedDateString {
            self.completedDate = str.toDate(withFormat: "dd-MM-yyyy hh:mm:ss a")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.userName, forKey: .userName)
        try container.encode(self.mobileNo, forKey: .mobileNo)
        try container.encode(self.addressId, forKey: .addressId)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.lat, forKey: .lat)
        try container.encode(self.long, forKey: .long)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.isComplete, forKey: .isComplete)
        try container.encode(self.storeName, forKey: .storeName)
        try container.encode(self.storeContactNo, forKey: .storeContactNo)
        try container.encode(self.orderType, forKey: .orderType)
        try container.encode(self.transactionType, forKey: .transactionType)
    }
}
