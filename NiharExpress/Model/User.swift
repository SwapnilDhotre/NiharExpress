//
//  User.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class User: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var mobileNo: String
    var emailId: String?
    var type: String?
    
    init(id: String, firstName: String, lastName: String, mobileNo: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.mobileNo = mobileNo
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case emailId = "email_id"
        case mobileNo = "mobile_no"
        case type
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id: String = try container.decode(String.self, forKey: .id)
        let firstName: String = try container.decode(String.self, forKey: .firstName)
        let lastName: String = try container.decode(String.self, forKey: .lastName)
        let mobileNo: String = try container.decode(String.self, forKey: .mobileNo)
        
        self.init(id: id, firstName: firstName, lastName: lastName, mobileNo: mobileNo)
        
        self.emailId = try? container.decode(String.self, forKey: .emailId)
        self.type = try? container.decode(String.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.mobileNo, forKey: .mobileNo)
        
        try? container.encode(self.emailId, forKey: .emailId)
        try? container.encode(self.type, forKey: .type)
    }
}
