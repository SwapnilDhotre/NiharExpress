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
    
    @IBOutlet weak var pickUpDeliveryTime: UIStackView!
    
    @IBOutlet weak var commentsView: UIStackView!
    @IBOutlet weak var lblCommentsTitle: UILabel!
    @IBOutlet weak var lblCommentsValue: UILabel!
    
    /// Store Info
    @IBOutlet weak var storeInfoView: UIView!
    @IBOutlet weak var lblStoreNameTitle: UILabel!
    @IBOutlet weak var lblStoreNameValue: UILabel!
    @IBOutlet weak var lblStoreContactTitle: UILabel!
    @IBOutlet weak var lblStoreContactValue: UILabel!
    @IBOutlet weak var lblStoreTransaction: UILabel!
    @IBOutlet weak var lblStoreTransactionValue: UILabel!
    
    
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
        
        /// Hiding logic
        // Hide show Time
        if address.isComplete == "N" {
            self.pickUpDeliveryTime.isHidden = true
        } else {
            self.pickUpDeliveryTime.isHidden = false
        }
        
        if (address.comment != "") {
            self.commentsView.isHidden = false
            self.lblCommentsValue.text = address.comment
        } else {
            self.commentsView.isHidden = true
        }
        
        if (address.orderType != nil && address.orderType! == "S") {
            self.storeInfoView.isHidden = false
            
            self.lblStoreNameTitle.text = "Store Name"
            self.lblStoreContactTitle.text = "Store Contact"
            self.lblStoreTransaction.text = "Transaction Amount"
            
            self.lblStoreNameValue.text = address.storeName
            self.lblStoreContactValue.text = address.storeContactNo
            
        } else {
            self.storeInfoView.isHidden = true
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
