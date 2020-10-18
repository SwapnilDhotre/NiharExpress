//
//  CouponCode.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 10/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class CouponCodeModel: Codable {
    var couponId: String
    var couponCode: String
    var discount: String
    var shouldApplyDiscount: Bool
    
    init(couponId: String, couponCode: String, discount: String, shouldApplyDiscount: Bool = true) {
        self.couponId = couponId
        self.couponCode = couponCode
        self.discount = discount
        self.shouldApplyDiscount = shouldApplyDiscount
    }
    
    enum CodingKeys: String, CodingKey {
        case couponId = "coupon_id"
        case couponCode = "coupon_code"
        case discount = "discount"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        let couponId: String = (try? container.decode(String.self, forKey: .couponId)) ?? ""
        let couponCode: String = (try? container.decode(String.self, forKey: .couponCode)) ?? ""
        let discount: String = (try? container.decode(String.self, forKey: .discount)) ?? ""
        
        self.init(couponId: couponId, couponCode: couponCode, discount: discount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.couponId, forKey: .couponId)
        try container.encode(self.couponCode, forKey: .couponCode)
        try container.encode(self.discount, forKey: .discount)
    }
}


