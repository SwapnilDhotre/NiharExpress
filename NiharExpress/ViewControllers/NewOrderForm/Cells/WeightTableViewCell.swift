//
//  WeightTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class WeightTableViewCell: UITableViewCell {
    static var identifier = "WeightTableViewCell"

    @IBOutlet weak var txtWeightField: UITextField!
    
    var formModel: FormFieldModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.txtWeightField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(with formField: FormFieldModel) {
        self.formModel = formField
        
        self.txtWeightField.text = formField.value as? String
    }
}

extension WeightTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.formModel?.value = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
