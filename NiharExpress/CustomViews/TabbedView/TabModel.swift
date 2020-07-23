//
//  TabModel.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class TabModel {
    var id: Int
    var title: String
    var icon: String
    var isSelected: Bool
    
    init(id: Int, title: String, icon: String = "", isSelected: Bool = false ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
    }
}
