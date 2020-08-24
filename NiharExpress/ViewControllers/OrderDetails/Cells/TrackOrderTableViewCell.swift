//
//  TrackOrderTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/23/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol TrackOrderProtocol {
    func trackOrderAction()
}

class TrackOrderTableViewCell: UITableViewCell {
     static var identifier = "TrackOrderTableViewCell"

    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet var lblOrderAmount: UILabel!
    @IBOutlet var lblDetailedAddress: UILabel!
    @IBOutlet var imgCourierBoy: UIImageView!
    
    @IBOutlet var lblCourierBoyName: UILabel!
    @IBOutlet var lblCourierBoyNo: UILabel!
    
    var delegate: TrackOrderProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(with order: Order) {
        self.lblOrderAmount.text = order.price
        self.lblDetailedAddress.text = order.pickUp.address
        self.lblCourierBoyName.text = order.driverName
        
        self.imgCourierBoy.pin_updateWithProgress = true
        self.imgCourierBoy.pin_setImage(from: URL(string: order.driverImage))
    }
    
    @IBAction func trackOrderAction(_ sender: UIButton) {
        self.delegate?.trackOrderAction()
    }
}
