//
//  AddressCommonTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol AddressCommonFieldProtocol {
    func tralingActionPerformed(for subFormFieldModel: FormSubFieldModel)
}

class AddressCommonTableViewCell: UITableViewCell {
    static var identifier = "AddressCommonTableViewCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnTraling: UIButton!
    @IBOutlet weak var txtField: UITextField!
    
    var model: FormSubFieldModel!
    var delegate: AddressCommonFieldProtocol?
    
    @IBOutlet weak var textFieldLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        self.txtField.delegate = self
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model = model
        
        self.lblTitle.text = model.title
        self.btnTraling.isHidden = true
        
        switch model.type {
        case .phoneNo:
            self.btnTraling.isHidden = false
            self.setPhoneButton(btn: self.btnTraling)
            
            self.txtField.delegate = self
            addPrefix91()
            break
        case .contactNo:
            self.textFieldLeadingConstraint.constant = 40
            self.txtField.delegate = self
            addPrefix91()
            break
        case .comment:
            self.lblTitle.font = FontUtility.roboto(style: .Italic, size: 12)
            break
        case .contactPerson:
            self.textFieldLeadingConstraint.constant = 40
            break
            
        default:
            break
        }
        
        self.txtField.text = model.value as? String
    }
    
    func addPrefix91() {
        let prefix = UILabel()
        prefix.text = "+91 "
        // set font, color etc.
        prefix.font = FontUtility.roboto(style: .Regular, size: 14)
        prefix.sizeToFit()
        
        self.txtField.leftView = prefix
        self.txtField.leftViewMode = .always
    }
    
    func setPhoneButton(btn: UIButton) {
        btn.titleLabel?.font = FontUtility.niharExpress(size: 20)
        btn.setTitle(AppIcons.conatctCard.rawValue, for: .normal)
        btn.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
    }
    
    @IBAction func btnTralingAction(_ sender: UIButton) {
        self.delegate?.tralingActionPerformed(for: self.model)
    }
}

extension AddressCommonTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.model.value = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.model.type == .phoneNo {
            
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
