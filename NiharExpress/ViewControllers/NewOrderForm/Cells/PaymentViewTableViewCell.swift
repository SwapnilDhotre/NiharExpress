//
//  PaymentViewTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol ContentFittingTableViewDelegate: UITableViewDelegate {
    func tableViewDidUpdateContentSize(_ tableView: UITableView)
}

protocol PaymentSelectedAddressProtocol {
    func paymentAddress(selectedIndex: Int)
}

class ContentFittingTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            if !constraints.isEmpty {
                invalidateIntrinsicContentSize()
            } else {
                sizeToFit()
            }
            
            if contentSize != oldValue {
                if let delegate = delegate as? ContentFittingTableViewDelegate {
                    delegate.tableViewDidUpdateContentSize(self)
                }
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return contentSize
    }
}

class PaymentViewTableViewCell: UITableViewCell {
    static var identifier = "PaymentViewTableViewCell"
    
    @IBOutlet weak var lblRadioIcon: UILabel!
    @IBOutlet weak var lblRupeeAmount: UILabel!
    @IBOutlet weak var lblCashAmount: UILabel!
    @IBOutlet weak var lblTickAmount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var selectedIndex: Int = 0
    var delegate: ReloadCellProtocol?
    var paymentAddressDelegate: PaymentSelectedAddressProtocol?
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
        self.lblRadioIcon.text = FontAwesome.dotCircle.rawValue
        self.lblRadioIcon.textColor = ColorConstant.themePrimary.color
        self.lblRadioIcon.font = UIFont.fontAwesome(ofSize: 20, style: .regular)
        
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
                    var userName = ""
                    if let nameField = (formModel.formSubFields.filter { $0.type == .name }).first {
                        userName = (nameField.value as? String) ?? ""
                        if userName != "" {
                            userName += " - "
                        }
                    }
                    
                    let address = userName + ((addressField.value as? AddressModel)?.address ?? "")
                    if address != "" {
                        locations.append(PaymentWillOccurAt(title: address, isSelected: false))
                    }
                }
            }
        }
        
        if selectedIndex < locations.count {
            locations[selectedIndex].isSelected = true
        }
        
        self.formFieldModel.paymentLocation = locations
        self.tableView.reloadData()
        
        self.tableView.layoutIfNeeded()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.formFieldModel.paymentLocation.forEach { $0.isSelected = false }
        self.formFieldModel.paymentLocation[indexPath.row].isSelected = true
        
        self.paymentAddressDelegate?.paymentAddress(selectedIndex: indexPath.row)
        
        self.tableView.reloadData()
    }
}
