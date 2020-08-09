//
//  OrderAddressView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class OrderAddressView: UIView {
    let kCONTENT_XIB_NAME = "OrderAddressView"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var designableRing: DesignableView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var upperLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    var isFirst: Bool = false {
        didSet {
            if self.isFirst {
                self.upperLine.isHidden = true
            } else {
                self.upperLine.isHidden = false
            }
        }
    }
    
    var isLast: Bool = false {
        didSet {
            if self.isLast {
                self.bottomLine.isHidden = true
            } else {
                self.bottomLine.isHidden = false
            }
        }
    }
    
    var filledRing: Bool = false {
        didSet {
            if self.filledRing {
                self.designableRing.backgroundColor = ColorConstant.themePrimary.color
            } else {
                self.designableRing.backgroundColor = UIColor.clear
            }
        }
    }
    
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
    }
}
