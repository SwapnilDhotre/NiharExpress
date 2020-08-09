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
        
        self.tableView.register(UINib(nibName: RadioCellTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RadioCellTableViewCell.identifier)
    }
    
    func updateData(with model: FormFieldModel, allFormFields: [FormFieldModel]) {
        self.formFieldModel = model
        
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
        
        self.tableViewHeightConstraint.constant = CGFloat(locations.count * 40)
        self.layoutIfNeeded()
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.formFieldModel.paymentLocation.forEach { $0.isSelected = false }
        self.formFieldModel.paymentLocation[indexPath.row].isSelected = true
        
        self.tableView.reloadData()
    }
}
