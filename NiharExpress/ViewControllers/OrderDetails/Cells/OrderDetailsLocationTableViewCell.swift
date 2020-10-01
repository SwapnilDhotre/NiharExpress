//
//  OrderDetailsLocationTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class OrderDetailsLocationTableViewCell: UITableViewCell {
    static var identifier = "OrderDetailsLocationTableViewCell"
    
    @IBOutlet weak var lblCounter: UILabel!
    
    @IBOutlet weak var lblDetailedAddress: UILabel!
    @IBOutlet weak var lblCourierTitle: UILabel!
    @IBOutlet weak var lblCourierTimeValue: UILabel!
    
    @IBOutlet weak var lblContactPersonTitle: UILabel!
    @IBOutlet weak var lblContactPersonValue: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    
    @IBOutlet weak var btnPhone: UIButton!
    
    @IBOutlet weak var upperLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    var contactNo: String = ""
    
    var isFirst: Bool = false {
        didSet {
            if self.isFirst {
                self.upperLine.isHidden = true
            } else {
                self.upperLine.isHidden = false
            }
        }
    }
    
    var isLast: Bool = false {
        didSet {
            if self.isLast {
                self.bottomLine.isHidden = true
            } else {
                self.bottomLine.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureUI() {
        self.btnPhone.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        self.btnPhone.setTitle(FontAwesome.phone.rawValue, for: .normal)
        self.btnPhone.setTitleColor(.darkGray, for: .normal)
    }
    
    func updateData(with address: OrderAddress, isDelivered: Bool) {
        if isDelivered {
            self.lblCourierTitle.text = "Courier visited this address"
        } else {
            self.lblCourierTitle.text = "Delivery Time"
        }
        
        if address.orderStatusType == .pickUp {
            self.lblCourierTitle.text = "Pickup Time"
            self.lblCourierTimeValue.text = address.completedDate?.toString(withFormat: "dd-MM-yyyy hh:mm:ss a")
        } else {
            self.lblCourierTitle.text = "Delivery Time"
        }
        
        self.lblDetailedAddress.text = address.address
        
        self.lblContactPersonValue.text = address.userName
        self.lblContactNo.text = address.mobileNo
        self.contactNo = address.mobileNo
    }
    
    @IBAction func btnPhoneCallAction(_ sender: UIButton) {
        if let url = URL(string: "tel://\(self.contactNo)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
