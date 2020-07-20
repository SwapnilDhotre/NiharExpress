//
//  AddDeliveryPointTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol AddDeliveryProtocol {
    func addDeliveryPoint()
}

class AddDeliveryPointTableViewCell: UITableViewCell {
    static var identifier = "AddDeliveryPointTableViewCell"

    var delegate: AddDeliveryProtocol?
    @IBOutlet weak var btnDeliveryPoint: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnDeliveryPoint.setImage(FontUtility.appImageIcon(code: AppIcons.outlineAddCircle.rawValue, textColor: ColorConstant.themePrimary.color, size: CGSize(width: 20, height: 20)), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func AddDeliveryPointAction(_ sender: UIButton) {
        self.delegate?.addDeliveryPoint()
    }
}
