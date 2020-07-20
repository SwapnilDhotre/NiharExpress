//
//  BottomCreateOrderView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class BottomCreateOrderView: UIView {
    let kCONTENT_XIB_NAME = "BottomCreateOrderView"
    
    var isArrowUp = false
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblForDeliveryTitle: UILabel!
    @IBOutlet weak var lblForDeliveryValue: UILabel!
    
    @IBOutlet weak var lblParcelSecurityFeeTitle: UILabel!
    @IBOutlet weak var lblParcelSecurityFeeValue: UILabel!
    
    @IBOutlet weak var lblArrowUpDown: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnCreateOrder: DesignableButton!
    
    @IBOutlet weak var createOrderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAmountClick: UIButton!
    
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
        
        self.toggleArrowUI()
    }
    
    func toggleArrowUI() {
        if self.isArrowUp {
            self.lblArrowUpDown.font = UIFont.fontAwesome(ofSize: 14, style: .light)
            self.lblArrowUpDown.text = FontAwesome.angleDown.rawValue
            self.lblArrowUpDown.textColor = ColorConstant.appBlackLabel.color
        } else {
            self.lblArrowUpDown.font = UIFont.fontAwesome(ofSize: 14, style: .light)
            self.lblArrowUpDown.text = FontAwesome.angleUp.rawValue
            self.lblArrowUpDown.textColor = ColorConstant.appBlackLabel.color
        }
        self.isArrowUp = !self.isArrowUp
    }
    
    func hideFields() {
        self.lblForDeliveryTitle.alpha = 0
        self.lblParcelSecurityFeeTitle.alpha = 0
        
        self.lblForDeliveryValue.alpha = 0
        self.lblParcelSecurityFeeValue.alpha = 0
    }
    
    func showFields() {
        self.lblForDeliveryTitle.alpha = 1
        self.lblParcelSecurityFeeTitle.alpha = 1
        
        self.lblForDeliveryValue.alpha = 1
        self.lblParcelSecurityFeeValue.alpha = 1
    }
}
