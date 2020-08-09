//
//  RemoveAddressTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol RemoveAddressProtocol {
    func removeAddress(model: FormSubFieldModel)
}

class RemoveAddressTableViewCell: UITableViewCell {
    static var identifier = "RemoveAddressTableViewCell"

    @IBOutlet weak var lblDeleteIcon: UILabel!
    
    var model: FormSubFieldModel!
    var delegate: RemoveAddressProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model = model
    }
    
    func configureUI() {
        self.lblDeleteIcon.text = FontAwesome.trash.rawValue
        self.lblDeleteIcon.font = UIFont.fontAwesome(ofSize: 14, style: .solid)
        self.lblDeleteIcon.textColor = UIColor.red
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.delegate?.removeAddress(model: self.model)
    }
}
