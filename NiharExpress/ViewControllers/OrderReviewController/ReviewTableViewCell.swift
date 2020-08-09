//
//  ReviewTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    static var identifier: String = "ReviewTableViewCell"
    
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateData(with counter: String, address: String, dateTime: String, mobileNo: String) {
        self.lblCounter.text = counter
        self.lblAddress.text = address
        self.lblDateTime.text = dateTime
        self.lblMobileNo.text = mobileNo
    }
    
}
