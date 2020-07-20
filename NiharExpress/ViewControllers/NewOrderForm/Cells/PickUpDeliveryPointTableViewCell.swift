//
//  PickUpDeliveryPointTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol ReloadCellProtocol {
    func reloadCell(for indexPath: IndexPath)
}

protocol LocationCellProtocol {
    func showDatePicker(indexPath: IndexPath)
    func pickLocation(indexPath: IndexPath)
}

class PickUpDeliveryPointTableViewCell: UITableViewCell {
    static var identifier = "PickUpDeliveryPointTableViewCell"
    
    @IBOutlet weak var lblFieldNo: UILabel!
    @IBOutlet weak var lblFormFieldTitle: UILabel!
    
    @IBOutlet weak var verticalLineView: UIView!
    
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var txtAddressField: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var addressLineView: UIView!
    
    @IBOutlet weak var lblPhoneNoTitle: UILabel!
    @IBOutlet weak var txtPhoneNoField: UITextField!
    @IBOutlet weak var btnContactPickUp: UIButton!
    @IBOutlet weak var phoneNoLineView: UIView!
    
    @IBOutlet weak var lblWhenToArriveTitle: UILabel!
    @IBOutlet weak var txtDateField: UITextField!
    @IBOutlet weak var txtTimeField: UITextField!
    @IBOutlet weak var lblCalendarIcon: UILabel!
    @IBOutlet weak var lblClockIcon: UILabel!
    @IBOutlet weak var whenToArriveLineView: UIView!
    
    @IBOutlet weak var lblCommentTitle: UILabel!
    @IBOutlet weak var txtCommentField: UITextField!
    @IBOutlet weak var commentLineView: UIView!
    
    @IBOutlet weak var lblForOnlineStore: UILabel!
    
    @IBOutlet weak var lblContactPersonTitle: UILabel!
    @IBOutlet weak var txtContactPersonField: UITextField!
    @IBOutlet weak var contactPersonLineView: UIView!
    
    @IBOutlet weak var lblContactNoTitle: UILabel!
    @IBOutlet weak var txtContactNoField: UITextField!
    @IBOutlet weak var contactNoLineView: UIView!
    
    @IBOutlet weak var txtTrasactionField: UITextField!
    @IBOutlet weak var transactionLineView: UIView!
    
    @IBOutlet weak var lblRupeesTitle: UILabel!
    @IBOutlet weak var txtRupeesField: UITextField!
    @IBOutlet weak var rupeesLineView: UIView!
    
    @IBOutlet weak var btnFormFieldCollapser: UIButton!
    @IBOutlet weak var btnFormNestedFieldCollapser: UIButton!
    @IBOutlet weak var formBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nestedFormBottomConstraint: NSLayoutConstraint!
    
    var indexPath: IndexPath!
    var delegate: ReloadCellProtocol?
    var locationCellDelegate: LocationCellProtocol?
    
    
    var model: FormFieldModel!
    
    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - To Do Methods
    func configureUI() {
        
        self.btnMap.titleLabel?.font = FontUtility.niharExpress(size: 20)
        self.btnMap.setTitle(AppIcons.aim_location.rawValue, for: .normal)
        self.btnMap.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
        
        self.btnContactPickUp.titleLabel?.font = FontUtility.niharExpress(size: 20)
        self.btnContactPickUp.setTitle(AppIcons.conatctCard.rawValue, for: .normal)
        self.btnContactPickUp.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
        
        self.lblCalendarIcon.font = FontUtility.niharExpress(size: 20)
        self.lblCalendarIcon.text = AppIcons.calendar.rawValue
        self.lblCalendarIcon.textColor = ColorConstant.appBlackLabel.color
        
        self.lblClockIcon.font = FontUtility.niharExpress(size: 20)
        self.lblClockIcon.text = AppIcons.clock.rawValue
        self.lblClockIcon.textColor = ColorConstant.appBlackLabel.color
        
        self.updateExpandCollapseBtn(sender: self.btnFormFieldCollapser, isCollapsed: false)
        self.updateExpandCollapseBtn(sender: self.btnFormNestedFieldCollapser, isCollapsed: true)
        
        self.txtAddressField.delegate = self
        self.txtCommentField.delegate = self
        self.txtContactPersonField.delegate = self
        self.txtContactNoField.delegate = self
        self.txtRupeesField.delegate = self
        self.txtTrasactionField.delegate = self
    }
    
    func updateExpandCollapseBtn(sender: UIButton, isCollapsed: Bool) {
        sender.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .regular)
        sender.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
        
        sender.setTitle(isCollapsed ? FontAwesome.angleDown.rawValue : FontAwesome.angleUp.rawValue, for: .normal)
    }
    
    func updateData(with model: FormFieldModel) {
        self.model = model
        
        self.lblFormFieldTitle.text = model.title
        
        self.lblFieldNo.text = "\(indexPath.row)"
        
        for formField in model.formSubFields {
            switch formField.type {
            case .address:
                self.txtAddressField.text = (formField.value as? AddressModel)?.address
            case .phoneNo:
                // Do nothing here
                break
            case .whenToPickup:
                if let fromToDate = (formField.value as? (fromDate: Date, toDate: Date)) {
                    self.txtDateField.text = fromToDate.fromDate.toString(withFormat: "dd-MM") + "-" + fromToDate.toDate.toString(withFormat: "dd-MM")
                    self.txtTimeField.text = fromToDate.fromDate.toString(withFormat: "HH:mm") + "-" + fromToDate.toDate.toString(withFormat: "HH:mm")
                }
                break
            case .whenToDelivery:
                if let fromToDate = (formField.value as? (fromDate: Date, toDate: Date)) {
                    self.txtDateField.text = fromToDate.fromDate.toString(withFormat: "dd-MM") + "-" + fromToDate.toDate.toString(withFormat: "dd-MM")
                    self.txtTimeField.text = fromToDate.fromDate.toString(withFormat: "HH:mm") + "-" + fromToDate.toDate.toString(withFormat: "HH:mm")
                }
                break
            case .comment:
                self.txtCommentField.text = formField.value as? String
                break
            case .contactPerson:
                self.txtContactPersonField.text = formField.value as? String
                break
            case .contactNo:
                self.txtContactNoField.text = formField.value as? String
                break
            case .transaction:
                self.txtTrasactionField.text = formField.value as? String
                break
            case .parcelType, .parcelValue, .promoCode, .notifyMeBySMS, .notifyRecipientsBySMS:
                break
            }
        }
        
        if model.isSubFieldsVisible {
            self.formBottomConstraint.priority = UILayoutPriority(rawValue: 920)
        } else {
            self.formBottomConstraint.priority = UILayoutPriority(rawValue: 940)
        }
        
        if model.isNestedSubFieldVisible {
            self.nestedFormBottomConstraint.constant = 230
            self.nestedFormBottomConstraint.priority = UILayoutPriority(rawValue: 950)
            
        } else {
            self.nestedFormBottomConstraint.priority = UILayoutPriority(rawValue: 900)
            self.nestedFormBottomConstraint.constant = 0
        }
        self.contentView.layoutIfNeeded()
        
        self.updateExpandCollapseBtn(sender: self.btnFormFieldCollapser, isCollapsed: !model.isSubFieldsVisible)
        self.updateExpandCollapseBtn(sender: self.btnFormNestedFieldCollapser, isCollapsed: !model.isNestedSubFieldVisible)
    }
    
    // MARK: - Action Methods
    @IBAction func btnTransactionAction(_ sender: Any) {
        
    }
    
    @IBAction func datePickerViewController(_ sender: Any) {
        self.locationCellDelegate?.showDatePicker(indexPath: self.indexPath)
    }
    
    @IBAction func btnFormFieldCollapserAction(_ sender: UIButton) {
        model.isSubFieldsVisible = !model.isSubFieldsVisible
        self.delegate?.reloadCell(for: self.indexPath)
    }
    
    @IBAction func btnFormNestedFieldCollapserAction(_ sender: UIButton) {
        model.isNestedSubFieldVisible = !model.isNestedSubFieldVisible
        self.delegate?.reloadCell(for: self.indexPath)
    }
    
    @IBAction func pickAddressAction(_ sender: UIButton) {
        self.locationCellDelegate?.pickLocation(indexPath: self.indexPath)
    }
}


extension PickUpDeliveryPointTableViewCell: UITextFieldDelegate {
 
}
