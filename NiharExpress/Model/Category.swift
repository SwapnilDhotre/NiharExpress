//
//  Category.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class Category: Codable {
    var id: String
    var title: String
    var isSelected: Bool
    
    init(id: String, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id: String = try container.decode(String.self, forKey: .id)
        let title: String = try container.decode(String.self, forKey: .title)
        
        self.init(id: id, title: title, isSelected: false)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
    }
}
