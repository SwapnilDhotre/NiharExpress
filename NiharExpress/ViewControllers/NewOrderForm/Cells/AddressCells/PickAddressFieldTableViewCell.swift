//
//  PickAddressFieldTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol PickAddressFieldProtocol {
    func fetchCurrentLocationAction(model: FormSubFieldModel)
}

class PickAddressFieldTableViewCell: UITableViewCell {
    static var identifier = "PickAddressFieldTableViewCell"
    
    @IBOutlet weak var btnMapAction: UIButton!
    @IBOutlet weak var txtAddressField: UITextView!
    
    var model: FormSubFieldModel!
    var delegate: PickAddressFieldProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        self.txtAddressField.delegate = self
        self.setMapIcon(to: self.btnMapAction)
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model = model
        
        self.btnMapAction.isHidden = !(model.isPickUpAddress ?? false)
        
        if let model = (self.model.value as? AddressModel) {
            self.txtAddressField.text = model.address
            if model.address == "" {
                self.txtAddressField.isUserInteractionEnabled = false
            } else {
                self.txtAddressField.isUserInteractionEnabled = true
            }
        } else {
            self.txtAddressField.isUserInteractionEnabled = false
        }
        
    }
    
    func setMapIcon(to btn: UIButton) {
        btn.titleLabel?.font = FontUtility.niharExpress(size: 20)
        btn.setTitle(AppIcons.aim_location.rawValue, for: .normal)
        btn.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
    }
    
    @IBAction func btnFetchCurrentLocationAction(_ sender: UIButton) {
        self.delegate?.fetchCurrentLocationAction(model: self.model)
    }
}

extension PickAddressFieldTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let model = (self.model.value as? AddressModel) {
            model.address = textView.text
            self.model.value = model
        }
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if textView.text == "" {
            self.txtAddressField.isUserInteractionEnabled = false
        } else {
            self.txtAddressField.isUserInteractionEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = text.components(separatedBy: cs).joined(separator: "")
        
        return (text == filtered)
    }
}
