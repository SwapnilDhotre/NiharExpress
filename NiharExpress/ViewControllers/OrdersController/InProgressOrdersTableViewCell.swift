//
//  InProgressOrdersTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class InProgressOrdersTableViewCell: UITableViewCell {
    static var identifier = "InProgressOrdersTableViewCell"

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var locationsStack: UIStackView!
    @IBOutlet weak var btnBell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateData(with order: Order) {
        self.lblAmount.text = order.price
        self.lblStatus.text = order.orderStatus
        self.lblOrderNo.text = order.orderNo
        
        self.btnBell.titleLabel?.font = FontUtility.niharExpress(size: 22)
        self.btnBell.setTitle(AppIcons.bell.rawValue, for: .normal)
        self.btnBell.setTitleColor(ColorConstant.themePrimary.color, for: .normal)
        
        self.locationsStack.arrangedSubviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        
        let pickAddressView = OrderAddressView()
        pickAddressView.isFirst = true
        pickAddressView.title.text = order.pickUp.address
        self.locationsStack.addArrangedSubview(pickAddressView)
        
        for index in 0..<order.delivery.count {
            let address = order.delivery[index]
            
            let deliveryAddressView = OrderAddressView()
            if index == order.delivery.count - 1 {
                deliveryAddressView.isLast = true
            }
            deliveryAddressView.title.text = address.address
            self.locationsStack.addArrangedSubview(deliveryAddressView)
        }
    }
}
