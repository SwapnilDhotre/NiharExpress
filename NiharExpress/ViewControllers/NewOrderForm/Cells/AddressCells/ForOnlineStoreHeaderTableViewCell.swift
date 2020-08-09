//
//  ForOnlineStoreHeaderTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol ForOnLineStoreProtocol {
    func onlineStoreToggle(model: FormSubFieldModel)
}

class ForOnlineStoreHeaderTableViewCell: UITableViewCell {
    static var identifier = "ForOnlineStoreHeaderTableViewCell"

    @IBOutlet weak var btnArrow: UIButton!
    var model: FormSubFieldModel!
    var delegate: ForOnLineStoreProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        self.modifyArrowBtn(isCollapsed: true)
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model = model
        self.modifyArrowBtn(isCollapsed: model.value as! Bool)
    }
    
    func modifyArrowBtn(isCollapsed: Bool) {
        self.btnArrow.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .regular)
        self.btnArrow.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
        
        self.btnArrow.setTitle(isCollapsed ? FontAwesome.angleUp.rawValue : FontAwesome.angleDown.rawValue, for: .normal)
    }
    
    @IBAction func btnArrowAction(_ sender: UIButton) {
        self.delegate?.onlineStoreToggle(model: self.model)
    }
}
