//
//  PromoCodeTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 10/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class PromoCodeTableViewCell: UITableViewCell {

    static var identifier: String = "PromoCodeTableViewCell"
    
    @IBOutlet weak var lblExpiryDateValue: UILabel!
    @IBOutlet weak var lblCouponCodeValue: UILabel!
    @IBOutlet weak var lblDiscountValue: UILabel!
    @IBOutlet weak var lblGeneratedByValue: UILabel!
    @IBOutlet weak var lblStatusValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
