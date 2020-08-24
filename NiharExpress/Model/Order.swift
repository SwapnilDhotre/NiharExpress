//
//  Order.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class Order: Codable {
    var orderId: String
    var orderNo: String
    var orderStatus: String
    var orderDate: Date
    
    var customerId: String
    var customerName: String
    var paymentMethod: String
    var weight: String
    var parcelType: String
    var orderType: String
    var pickUp: OrderAddress
    var delivery: [OrderAddress]
 
    var parcelValue: String
    var insurancePrice: String
    var price: String
    
    var driverName: String
    var driveMobileNo: String
    var driverImage: String
    var driverRating: String
    
    var comment: String?
    var overallRating: String?
    
    var unreadNotification: String?
    var readNotification: String?
    
    init(orderId: String, orderNo: String, orderStatus: String, orderDate: Date, customerId: String, customerName: String, paymentMethod: String, weight: String, parcelType: String, orderType: String, pickUp: OrderAddress, delivery: [OrderAddress], parcelValue: String, insurancePrice: String, price: String, driverName: String, driveMobileNo: String, driverImage: String, driverRating: String, comment: String?, overallRating: String?, unreadNotification: String, readNotification: String) {
        
        self.orderId = orderId
        self.orderNo = orderNo
        self.orderStatus = orderStatus
        self.orderDate = orderDate
        self.customerId = customerId
        self.customerName = customerName
        self.paymentMethod = paymentMethod
        self.weight = weight
        self.parcelType = parcelType
        self.orderType = orderType
        self.pickUp = pickUp
        self.delivery = delivery
        self.parcelValue = parcelValue
        self.insurancePrice = insurancePrice
        self.price = price
        self.driverName = driverName
        self.driveMobileNo = driveMobileNo
        self.driverImage = driverImage
        self.driverRating = driverRating
        self.comment = comment
        self.overallRating = overallRating
        self.unreadNotification = unreadNotification
        self.readNotification = readNotification
    }
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderNo = "order_no"
        case orderStatus = "order_status"
        case orderDate = "order_date" /// 30-07-2020 02:52:12 pm
        
        case customerId = "customer_id"
        case customerName = "customer_name"
        case paymentMethod = "payment_method"
        case weight = "weight"
        case parcelType = "parcel_type"
        case orderType = "order_type"
        case pickUp = "pickup"
        case delivery = "delivery"
        
        case parcelValue = "parcel_value"
        case insurancePrice = "insurance_price"
        case price = "price"
        
        case driverName = "driver_name"
        case driveMobileNo = "driver_mobile_no"
        case driverImage = "driver_image"
        case driverRating = "driver_rating"

        case comment = "comment"
        case overallRating = "overall_rating"
        
        case unreadNotification = "unread_notification"
        case readNotification = "read_notification"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let orderId: String = try container.decode(String.self, forKey: .orderId)
        let orderNo: String = try container.decode(String.self, forKey: .orderNo)
        let orderStatus: String = try container.decode(String.self, forKey: .orderStatus)
        let orderDateString: String = try container.decode(String.self, forKey: .orderDate)
        let orderDate: Date = orderDateString.toDate(withFormat: "dd-MM-yyyy hh:mm:ss a") ?? Date() //30-07-2020 02:52:12 pm
        
        let customerId: String = try container.decode(String.self, forKey: .customerId)
        let customerName: String = try container.decode(String.self, forKey: .customerName)
        let paymentMethod: String = try container.decode(String.self, forKey: .paymentMethod)
        let weight: String = try container.decode(String.self, forKey: .weight)
        let parcelType: String = try container.decode(String.self, forKey: .parcelType)
        let orderType: String = try container.decode(String.self, forKey: .orderType)
        let pickUp: OrderAddress = try container.decode(OrderAddress.self, forKey: .pickUp)
        let delivery: [OrderAddress] = (try? container.decode([OrderAddress].self, forKey: .delivery)) ?? []
        
        let parcelValue: String = try container.decode(String.self, forKey: .parcelValue)
        let insurancePrice: String = try container.decode(String.self, forKey: .insurancePrice)
        let price: String = try container.decode(String.self, forKey: .price)
        
        let driverName: String = try container.decode(String.self, forKey: .driverName)
        let driveMobileNo: String = try container.decode(String.self, forKey: .driveMobileNo)
        let driverImage: String = (try? container.decode(String.self, forKey: .driverImage)) ?? ""
        let driverRating: String = (try? container.decode(String.self, forKey: .driverRating)) ?? ""
        
        let comment: String? = try? container.decode(String.self, forKey: .comment)
        let overallRating: String? = try? container.decode(String.self, forKey: .overallRating)
        
        let unreadNotification: String = (try? container.decode(String.self, forKey: .unreadNotification)) ?? ""
        let readNotification: String = (try? container.decode(String.self, forKey: .readNotification)) ?? ""
        
        self.init(orderId: orderId,
                  orderNo: orderNo,
                  orderStatus: orderStatus,
                  orderDate: orderDate,
                  customerId: customerId,
                  customerName: customerName,
                  paymentMethod: paymentMethod,
                  weight: weight,
                  parcelType: parcelType,
                  orderType: orderType,
                  pickUp: pickUp,
                  delivery: delivery,
                  parcelValue: parcelValue,
                  insurancePrice: insurancePrice,
                  price: price,
                  driverName: driverName,
                  driveMobileNo: driveMobileNo,
                  driverImage: driverImage,
                  driverRating: driverRating,
                  comment: comment,
                  overallRating: overallRating,
                  unreadNotification: unreadNotification,
                  readNotification: readNotification)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
                
        try container.encode(self.orderId, forKey: .orderId)
        try container.encode(self.orderNo, forKey: .orderNo)
        try container.encode(self.orderStatus, forKey: .orderStatus)
        try container.encode(self.orderDate, forKey: .orderDate)
        try container.encode(self.customerId, forKey: .customerId)
        try container.encode(self.customerName, forKey: .customerName)
        try container.encode(self.paymentMethod, forKey: .paymentMethod)
        try container.encode(self.weight, forKey: .weight)
        try container.encode(self.parcelType, forKey: .parcelType)
        try container.encode(self.orderType, forKey: .orderType)
        try container.encode(self.pickUp, forKey: .pickUp)
        try container.encode(self.delivery, forKey: .delivery)
        try container.encode(self.parcelValue, forKey: .parcelValue)
        try container.encode(self.insurancePrice, forKey: .insurancePrice)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.driverName, forKey: .driverName)
        try container.encode(self.driveMobileNo, forKey: .driveMobileNo)
        try container.encode(self.driverImage, forKey: .driverImage)
        try container.encode(self.driverRating, forKey: .driverRating)
        try? container.encode(self.comment, forKey: .comment)
        try? container.encode(self.overallRating, forKey: .overallRating)
        try container.encode(self.unreadNotification, forKey: .unreadNotification)
        try container.encode(self.readNotification, forKey: .readNotification)
    }
    
}
