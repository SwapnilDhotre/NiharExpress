//
//  CouponModel.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 10/4/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class CouponModel: Codable {
    var couponCode: String
    var discount: String
    var expiryDate: String
    var generatedBy: String
    var isUsed: Bool
    
    init(couponCode: String, discount: String, expiryDate: String, generatedBy: String, isUsed: Bool) {
        self.couponCode = couponCode
        self.discount = discount
        self.expiryDate = expiryDate
        self.generatedBy = generatedBy
        self.isUsed = isUsed
    }
    
    enum CodingKeys: String, CodingKey {
        case couponCode = "coupon_code"
        case discount = "discount"
        case expiryDate = "expiry_date"
        case generatedBy = "generated_by"
        case isUsed = "is_used"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        let couponCode: String = (try? container.decode(String.self, forKey: .couponCode)) ?? ""
        let discount: String = (try? container.decode(String.self, forKey: .discount)) ?? ""
        let expiryDate: String = (try? container.decode(String.self, forKey: .expiryDate)) ?? ""
        let generatedBy: String = (try? container.decode(String.self, forKey: .generatedBy)) ?? ""
        let isUsed: Bool = ((try? container.decode(String.self, forKey: .generatedBy)) ?? "") == "N" ? false : true
        
        self.init(couponCode: couponCode, discount: discount, expiryDate: expiryDate, generatedBy: generatedBy, isUsed: isUsed)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.couponCode, forKey: .couponCode)
        try container.encode(self.discount, forKey: .discount)
        try container.encode(self.expiryDate, forKey: .expiryDate)
        try container.encode(self.generatedBy, forKey: .generatedBy)
        try container.encode(self.isUsed, forKey: .isUsed)
    }
}
