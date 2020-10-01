//
//  OrderDeliveredTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import PINRemoteImage

protocol OrderDeliveredProtocol {
    func cloneAction()
    func starAction()
}

class OrderDeliveredTableViewCell: UITableViewCell {
    static var identifier = "OrderDeliveredTableViewCell"

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCourierBoyName: UILabel!
    @IBOutlet weak var lblCourierBoyMob: UILabel!
    @IBOutlet weak var courierBoyImage: UIImageView!
    
    @IBOutlet weak var btnClone: UIButton!
    
    var delegate: OrderDeliveredProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(with order: Order) {
        self.lblAmount.text = order.price
        self.lblAddress.text = order.pickUp.address
        self.lblCourierBoyName.text = order.driverName
        self.lblCourierBoyMob.text = order.driveMobileNo
        
        self.courierBoyImage.pin_updateWithProgress = true
        self.courierBoyImage.pin_setImage(from: URL(string: order.driverImage))
    }
    
    @IBAction func btnCloneAction(_ sender: UIButton) {
        self.delegate?.cloneAction()
    }
    
    @IBAction func btnStarAction(_ sender: UIButton) {
        self.delegate?.starAction()
    }
}
