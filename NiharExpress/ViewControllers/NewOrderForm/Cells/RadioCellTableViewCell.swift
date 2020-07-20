//
//  RadioCellTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class PaymentWillOccurAt {
    var title: String
    var isSelected: Bool
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}

class RadioCellTableViewCell: UITableViewCell {
    static var identifier = "RadioCellTableViewCell"

    @IBOutlet weak var lblRadioIcon: UILabel!
    @IBOutlet weak var lblRadioTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        self.lblRadioIcon.text = FontAwesome.circle.rawValue
        self.lblRadioIcon.textColor = ColorConstant.themePrimary.color
        self.lblRadioIcon.font = UIFont.fontAwesome(ofSize: 20, style: .regular)
    }
    
    func updateData(with model: PaymentWillOccurAt) {
        self.lblRadioTitle.text = model.title
        self.lblRadioIcon.text = model.isSelected ? FontAwesome.dotCircle.rawValue : FontAwesome.circle.rawValue
    }
}
