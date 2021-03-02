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
    func cloneOrder()
}

class TrackOrderTableViewCell: UITableViewCell {
    static var identifier = "TrackOrderTableViewCell"
    
    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet var lblOrderAmount: UILabel!
    @IBOutlet var lblDetailedAddress: UILabel!
    @IBOutlet var imgCourierBoy: UIImageView!
    
    @IBOutlet var lblCourierBoyName: UILabel!
    @IBOutlet var lblCourierBoyNo: UILabel!
    @IBOutlet weak var btnTrackOrder: DesignableButton!
    @IBOutlet weak var btnPhone: UIButton!
    
    var delegate: TrackOrderProtocol?
    var contactNo: String = ""
    
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
        self.lblCourierBoyNo.text = order.driveMobileNo
        self.contactNo = order.driveMobileNo
        
        self.btnPhone.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        self.btnPhone.setTitle(FontAwesome.phone.rawValue, for: .normal)
        self.btnPhone.setTitleColor(.darkGray, for: .normal)
                
        // driver info
        if order.driverName != "" {
            self.lblCourierBoyName.text = order.driverName
            //self.text = order.driveMobileNo
            self.imgCourierBoy.pin_updateWithProgress = true
            self.imgCourierBoy.pin_setImage(from: URL(string: order.driverImage))
            self.btnPhone.isHidden = false
        } else {
            self.lblCourierBoyName.text = "Driver Not Assign"
            self.btnPhone.isHidden = true
        }
    }
    
    @IBAction func trackOrderAction(_ sender: UIButton) {
        self.delegate?.trackOrderAction()
    }
    
    @IBAction func callCourierBoy(_ sender: Any) {
        if let url = URL(string: "tel://\(self.contactNo)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func cloneOrderAction(_ sender: UIButton) {
        self.delegate?.cloneOrder()
    }
}
