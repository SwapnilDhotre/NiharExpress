//
//  City.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/6/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class City: Codable {
    var id: String
    var name: String
    var isSelected: Bool = false
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id: String = try container.decode(String.self, forKey: .id)
        let name: String = try container.decode(String.self, forKey: .name)
        
        self.init(id: id, name: name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
}
