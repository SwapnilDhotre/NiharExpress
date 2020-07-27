//
//  RegistrationView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/20/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol RegistrationViewProtocol {
    func registerData(with fullName: String, phoneNumber: String, emailId: String, verifyOtp: String)
    func getOTP(with fullName: String, phoneNumber: String)
}

class RegistrationView: UIView {
    
    let kCONTENT_XIB_NAME = "RegistrationView"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var txtFieldFullName: UITextField!
    @IBOutlet weak var bottomLineFullName: UIView!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var bottomLinePhoneNumber: UIView!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var bottomLineEmail: UIView!
    
    @IBOutlet weak var lblVerificationCode: UILabel!
    @IBOutlet weak var txtFieldVerificationCode: UITextField!
    @IBOutlet weak var bottomLineVerificationCOde: UIView!
    
    @IBOutlet weak var btnRegister: DesignableButton!
    @IBOutlet weak var btnRequestOTP: UIButton!
    
    var delegate: RegistrationViewProtocol?
    
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
    
    // MARK: - Action Methods
    @IBAction func requestOTPAction(_ sender: UIButton) {
        let fullName = self.txtFieldFullName.text ?? ""
        let phoneNumber = self.txtFieldPhoneNumber.text ?? ""
        
        self.delegate?.getOTP(with: fullName, phoneNumber: phoneNumber)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let fullName = self.txtFieldFullName.text ?? ""
        let phoneNumber = self.txtFieldPhoneNumber.text ?? ""
        let emailId = self.txtFieldEmail.text ?? ""
        let verifyCode = self.txtFieldVerificationCode.text ?? ""
        
        self.delegate?.registerData(with: fullName, phoneNumber: phoneNumber, emailId: emailId, verifyOtp: verifyCode)
    }
}
