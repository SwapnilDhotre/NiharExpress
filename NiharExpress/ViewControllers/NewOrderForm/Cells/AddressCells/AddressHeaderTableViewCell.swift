//
//  AddressHeaderTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol AddressHeaderProtocol {
    func arrowActionPerformed(model: FormSubFieldModel)
}

class AddressHeaderTableViewCell: UITableViewCell {
    static var identifier = "AddressHeaderTableViewCell"

    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var btnArrow: UIButton!
    
    var model: FormSubFieldModel!
    var delegate: AddressHeaderProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model = model
        self.lblHeaderTitle.text = model.title
        self.lblCounter.text = "\(model.parentIndex ?? 0)"
        
        self.modifyArrowBtn(isCollapsed: model.value as! Bool)
    }
    
    func modifyArrowBtn(isCollapsed: Bool) {
        self.btnArrow.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .regular)
        self.btnArrow.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
        
        self.btnArrow.setTitle(isCollapsed ? FontAwesome.angleUp.rawValue : FontAwesome.angleDown.rawValue, for: .normal)
    }
    
    @IBAction func btnArrowAction(_ sender: UIButton) {
        self.delegate?.arrowActionPerformed(model: self.model)
    }
}
