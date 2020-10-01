//
//  InformationTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {
    static var identifier = "InformationTableViewCell"
    
    @IBOutlet weak var lblOrderCreatedDate: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDeliveryMethod: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblStatedValue: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(wtih order: Order) {
        self.lblOrderCreatedDate.text = order.orderDate.toString(withFormat: "MMM dd, yyyy")
        self.lblWeight.text = order.weight
        self.lblDeliveryMethod.text = order.orderType
        self.lblContent.text = order.parcelType
        self.lblStatedValue.text = "₹\(order.parcelValue)"
        self.lblPaymentType.text = order.paymentMethod
    }
}
