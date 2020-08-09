//
//  ParcelTypeCollectionViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class ParcelTypeCollectionViewCell: UICollectionViewCell {

    static var identifier = "ParcelTypeCollectionViewCell"
    
    @IBOutlet weak var lblParcelType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblParcelType.font = FontUtility.roboto(style: .Medium, size: 12)
        
    }
}
