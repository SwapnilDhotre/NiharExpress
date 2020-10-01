//
//  PaymentViewTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class PaymentViewTableViewCell: UITableViewCell {
    static var identifier = "PaymentViewTableViewCell"
    
    @IBOutlet weak var lblRupeeAmount: UILabel!
    @IBOutlet weak var lblCashAmount: UILabel!
    @IBOutlet weak var lblTickAmount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: ReloadCellProtocol?
    var formFieldModel: FormFieldModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureUI() {
        self.lblTickAmount.font = UIFont.fontAwesome(ofSize: 22, style: .regular)
        self.lblTickAmount.text = FontAwesome.check.rawValue
        self.lblTickAmount.textColor = ColorConstant.appBlackLabel.color
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        self.tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: RadioCellTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RadioCellTableViewCell.identifier)
    }
    
    func updateData(with model: FormFieldModel, allFormFields: [FormFieldModel]) {
        self.formFieldModel = model
        
        self.tableViewHeightConstraint.constant = 500
        
        var locations: [PaymentWillOccurAt] = []
        for formModel in allFormFields {
            if formModel.type == .pickUpPoint || formModel.type == .deliveryPoint {
                if let addressField = (formModel.formSubFields.filter { $0.type == .address }).first {
                    
                    if let address = (addressField.value as? AddressModel)?.address, address != "" {
                        locations.append(PaymentWillOccurAt(title: address, isSelected: false))
                    }
                }
            }
        }
        self.formFieldModel.paymentLocation = locations
        self.tableView.reloadData()
        
//        UIView.animate(withDuration: 0, animations: {
//            self.tableView.layoutIfNeeded()
//            }) { (complete) in
//                var heightOfTableView: CGFloat = 0.0
//                // Get visible cells and sum up their heights
//                let cells = self.tableView.visibleCells
//                for cell in cells {
//                    heightOfTableView += cell.frame.height
//                }
//                // Edit heightOfTableViewConstraint's constant to update height of table view
//                self.tableViewHeightConstraint.constant = heightOfTableView
//        }
        
//        self.tableViewHeightConstraint.constant = CGFloat(locations.count * 40)
//        self.layoutIfNeeded()
        
        
    }
}

extension PaymentViewTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formFieldModel.paymentLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioCellTableViewCell.identifier) as? RadioCellTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(RadioCellTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.updateData(with: self.formFieldModel.paymentLocation[indexPath.row])
        
        if indexPath.row ==  self.formFieldModel.paymentLocation.count - 1 {
        UIView.animate(withDuration: 0, animations: {
        self.tableView.layoutIfNeeded()
        }) { (complete) in
            var heightOfTableView: CGFloat = 0.0
            // Get visible cells and sum up their heights
            let cells = self.tableView.visibleCells
            for cell in cells {
                heightOfTableView += cell.frame.height
            }
            // Edit heightOfTableViewConstraint's constant to update height of table view
            self.tableViewHeightConstraint.constant = heightOfTableView
        }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.formFieldModel.paymentLocation.forEach { $0.isSelected = false }
        self.formFieldModel.paymentLocation[indexPath.row].isSelected = true
        
        self.tableView.reloadData()
    }
}
