//
//  LoadingCellTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 12/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class LoadingCellTableViewCell: UITableViewCell {
    static var identifier = "LoadingCellTableViewCell"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
