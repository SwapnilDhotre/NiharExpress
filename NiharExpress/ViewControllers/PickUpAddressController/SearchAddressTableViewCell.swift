//
//  SearchAddressTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 28/09/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class SearchAddressTableViewCell: UITableViewCell {
    static var identifier: String = "SearchAddressTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
