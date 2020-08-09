//
//  ProfileTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    static var identifier: String = "ProfileTableViewCell"
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblIcon: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTrailing: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(with icon: String, title: String, subTitle: String, trailing: String) {
        self.lblIcon.font = FontUtility.niharExpress(size: 28)
        self.lblIcon.textColor = ColorConstant.themePrimary.color
        
        self.lblIcon.text = icon
        
        self.lblTitle.text = title
        self.lblSubTitle.text = subTitle
        self.lblTrailing.text = trailing
        
        if subTitle == "" {
            self.stackView.removeArrangedSubview(self.lblSubTitle)
        }
    }
}
