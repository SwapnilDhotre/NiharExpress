//
//  SingleLineCollectionViewCell.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class SingleLineCollectionViewCell: UICollectionViewCell {

    static let identifier = "SingleLineCollectionViewCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateView(with title: String) {
        self.lblTitle.text = title
    }
    
    func setTitleFont(font: UIFont, color: UIColor) {
        self.lblTitle.font = font
        self.lblTitle.textColor = color
    }
}
