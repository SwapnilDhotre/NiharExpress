//
//  NavigationView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    let kCONTENT_XIB_NAME = "NavigationView"
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var leftNavigationButton: UIButton!
    @IBOutlet weak var rightNavigationButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        self.leftNavigationButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .light)
        self.leftNavigationButton.setTitle(FontAwesome.times.rawValue, for: .normal)
        self.leftNavigationButton.setTitleColor(ColorConstant.themePrimary.color, for: .normal)
    }
}
