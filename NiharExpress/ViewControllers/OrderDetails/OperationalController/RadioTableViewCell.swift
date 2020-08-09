//
//  RadioTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell {
    static var identifier = "RadioTableViewCell"

    @IBOutlet weak var lblRadio: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var isRadioSelected: Bool = false {
        didSet {
            if isRadioSelected {
                self.lblRadio.text = AppIcons.radioSelected.rawValue
            } else {
                self.lblRadio.text = AppIcons.radioUnSelected.rawValue
            }
        }
    }
    
    var radioColor: UIColor = ColorConstant.themePrimary.color {
        didSet {
            self.lblRadio.textColor = self.radioColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        self.lblRadio.font = FontUtility.niharExpress(size: 18)
        self.lblRadio.textColor = self.radioColor
        self.lblRadio.text = AppIcons.radioUnSelected.rawValue
    }
    
}
