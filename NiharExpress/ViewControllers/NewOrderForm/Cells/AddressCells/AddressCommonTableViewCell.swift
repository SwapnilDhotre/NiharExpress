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
            break
        case .contactPerson, .contactNo:
            self.textFieldLeadingConstraint.constant = 40
            break
        default:
            break
        }
        
        self.txtField.text = model.value as? String
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
}
