//
//  LoginView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/21/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    let kCONTENT_XIB_NAME = "LoginView"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblPhoneOrEmail: UILabel!
    @IBOutlet weak var txtFieldPhoneOrEmail: UITextField!
    @IBOutlet weak var bottomLinePhoneOrEmail: UIView!
    
    @IBOutlet weak var btnRequestOTP: UIButton!
    
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
    
    @IBAction func requestOTPAction(_ sender: UIButton) {
        
    }
}
