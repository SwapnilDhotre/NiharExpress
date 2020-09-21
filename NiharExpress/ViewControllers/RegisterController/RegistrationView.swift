//
//  RegistrationView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/20/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol RegistrationViewProtocol {
    func registerData(with fullName: String, phoneNumber: String, emailId: String)
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
        
        self.txtFieldPhoneNumber.delegate = self
        self.addPrefix91()
    }
    
    func addPrefix91() {
        let prefix = UILabel()
        prefix.text = "+91 "
        // set font, color etc.
        prefix.font = UIFont.systemFont(ofSize: 14)
        prefix.sizeToFit()

        self.txtFieldPhoneNumber.leftView = prefix
        self.txtFieldPhoneNumber.leftViewMode = .always
    }
    
    // MARK: - Action Methods
    @IBAction func registerAction(_ sender: UIButton) {
        let fullName = self.txtFieldFullName.text ?? ""
        let phoneNumber = self.txtFieldPhoneNumber.text ?? ""
        let emailId = self.txtFieldEmail.text ?? ""
        
        self.delegate?.registerData(with: fullName, phoneNumber: phoneNumber, emailId: emailId)
    }
}

extension RegistrationView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtFieldPhoneNumber {
            
            // This will avoid any non-digit no to enter and will allow backspace
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                } else if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {} else {
                    return false
                }
            }
            
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        } else {
            return true
        }
    }
}
