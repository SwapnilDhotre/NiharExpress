//
//  CompletedOrderTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import Cosmos

class CompletedOrderTableViewCell: UITableViewCell {
    static var identifier = "CompletedOrderTableViewCell"

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCompletedDate: UILabel!
    
    @IBOutlet weak var locationsStack: UIStackView!
    @IBOutlet weak var ratingView: CosmosView!
    
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
        self.lblCompletedDate.text = "Completed \(order.orderDate.toString(withFormat: "dd-MM-yyyy hh:mm:ss a"))"
        self.lblOrderNo.text = order.orderNo
        
        self.locationsStack.arrangedSubviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        
        let pickAddressView = OrderAddressView()
        pickAddressView.isFirst = true
        pickAddressView.title.text = order.pickUp.address
        pickAddressView.filledRing = order.pickUp.isComplete == "Y"
        self.locationsStack.addArrangedSubview(pickAddressView)
        
        for index in 0..<order.delivery.count {
            let address = order.delivery[index]
            
            let deliveryAddressView = OrderAddressView()
            if index == order.delivery.count - 1 {
                deliveryAddressView.isLast = true
            }
            deliveryAddressView.title.text = address.address
            deliveryAddressView.filledRing = address.isComplete == "Y"
            self.locationsStack.addArrangedSubview(deliveryAddressView)
        }
    }
}
