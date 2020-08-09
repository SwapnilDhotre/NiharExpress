//
//  PriceInfo.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/6/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class PriceInfo: Codable {
    
    var insuranceCost: String
    var minimumPrice: String
    var totalCost: String
    var price: String
    var deliveryStopCost: String
    var distance: Int
    
    init(insuranceCost: String, minimumPrice: String, totalCost: String, price: String, deliveryStopCost: String, distance: Int) {
        self.insuranceCost = insuranceCost
        self.minimumPrice = minimumPrice
        self.totalCost = totalCost
        self.price = price
        self.deliveryStopCost = deliveryStopCost
        self.distance = distance
    }
    
    enum CodingKeys: String, CodingKey {
        case insuranceCost = "insurance_cost"
        case minimumPrice = "minimum_price"
        case totalCost = "total_cost"
        case price = "price"
        case deliveryStopCost = "delivery_stop_cost"
        case distance = "distance"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let insuranceCost = try container.decode(String.self, forKey: .insuranceCost)
        let minimumPrice = try container.decode(String.self, forKey: .minimumPrice)
        var totalCost: String = ""
        if let cost = try? container.decode(String.self, forKey: .totalCost) {
            totalCost = cost
        }
        if let cost = try? container.decode(Int.self, forKey: .totalCost) {
            totalCost = "\(cost)"
        }
        let price = try container.decode(String.self, forKey: .price)
        let deliveryStopCost = try container.decode(String.self, forKey: .deliveryStopCost)
        let distance = try container.decode(Int.self, forKey: .distance)
        
        self.init(insuranceCost: insuranceCost, minimumPrice: minimumPrice, totalCost: totalCost, price: price, deliveryStopCost: deliveryStopCost, distance: distance)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.insuranceCost, forKey: .insuranceCost)
        try container.encode(self.minimumPrice, forKey: .minimumPrice)
        try container.encode(self.totalCost, forKey: .totalCost)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.deliveryStopCost, forKey: .deliveryStopCost)
        try container.encode(self.distance, forKey: .distance)
    }
}
