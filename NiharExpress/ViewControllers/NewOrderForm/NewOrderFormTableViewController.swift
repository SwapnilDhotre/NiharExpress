//
//  NewOrderFormTableViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import CoreLocation
import ContactsUI

protocol FormDelegate {
    func formDismissal()
}

class NewOrderFormTableViewController: UITableViewController {
    
    var delegate: FormDelegate?
    var navigationView: NavigationView!
    var bottomPanelView: BottomCreateOrderView!
    
    var bottomPanelViewHeightConstraint: NSLayoutConstraint!
    
    var formFields: [FormFieldModel] = []
    var tableViewFormFields: [Any] = []
    
    var parcelCategories: [Category] = []
    var priceInfo: PriceInfo?
    
    var paymentWillOccurAtIndex: Int = 0
    
    var alertLoader: UIAlertController?
    var phoneNumberField: FormSubFieldModel?
    private let contactPicker = CNContactPickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
        self.configureTopBottomUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationView?.removeFromSuperview()
        self.bottomPanelView?.removeFromSuperview()
    }
    
    // MARK: - To Do Methods
    func configureUI() {
        if self.formFields.isEmpty {
            self.formFields = FormFieldModel.getFormFields()
        } else {
            self.calculatePrice()
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let topPadding: CGFloat = 70
        let bottomPadding: CGFloat = 110
        self.tableView.contentInset = UIEdgeInsets.init(top: topPadding, left: 0, bottom: bottomPadding, right: 0)
        
        self.tableView.register(UINib(nibName: WeightTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WeightTableViewCell.identifier)
        self.tableView.register(UINib(nibName: AddDeliveryPointTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AddDeliveryPointTableViewCell.identifier)
        self.tableView.register(UINib(nibName: OptimizeRouteTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OptimizeRouteTableViewCell.identifier)
        self.tableView.register(UINib(nibName: NotifyBySMSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotifyBySMSTableViewCell.identifier)
        self.tableView.register(UINib(nibName: ParcelInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParcelInfoTableViewCell.identifier)
        self.tableView.register(UINib(nibName: PaymentViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PaymentViewTableViewCell.identifier)
        
        self.tableView.register(UINib(nibName: AddressCommonTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AddressCommonTableViewCell.identifier)
        self.tableView.register(UINib(nibName: AddressHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AddressHeaderTableViewCell.identifier)
        self.tableView.register(UINib(nibName: DateTimePickerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DateTimePickerTableViewCell.identifier)
        self.tableView.register(UINib(nibName: ForOnlineStoreHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForOnlineStoreHeaderTableViewCell.identifier)
        self.tableView.register(UINib(nibName: PickAddressFieldTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PickAddressFieldTableViewCell.identifier)
        self.tableView.register(UINib(nibName: RemoveAddressTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RemoveAddressTableViewCell.identifier)
        self.tableView.register(UINib(nibName: TransactionTypeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TransactionTypeTableViewCell.identifier)
        
        
        self.fetchParcelCategories { (parcelTypes: [Category]) in
            DispatchQueue.main.async {
                self.parcelCategories = parcelTypes
                self.tableView.reloadData()
            }
        }
    }
    
    func configureTopBottomUI() {
        
        self.navigationView = NavigationView()
        self.bottomPanelView = BottomCreateOrderView()
        
        self.navigationView.leftNavigationButton.addTarget(self, action: #selector(self.crossBtnAction(_:)), for: .touchUpInside)
        self.navigationView.rightNavigationButton.addTarget(self, action: #selector(self.clearDataBtnAction(_:)), for: .touchUpInside)
        //        self.bottomPanelView.btnAmountClick.addTarget(self, action: #selector(self.btnAmountClick), for: .touchUpInside)
        self.bottomPanelView.btnCreateOrder.addTarget(self, action: #selector(self.btnCreateOrderClick(_:)), for: .touchUpInside)
        
        if let view = UIApplication.shared.keyWindow{
            view.addSubview(self.navigationView)
            view.addSubview(self.bottomPanelView)
            
            self.navigationView.translatesAutoresizingMaskIntoConstraints = false
            self.bottomPanelView.translatesAutoresizingMaskIntoConstraints = false
            
            self.navigationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            self.navigationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            self.navigationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            self.bottomPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            self.bottomPanelView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            self.bottomPanelView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            if UIDevice.current.hasNotch {
                self.navigationView.heightAnchor.constraint(equalToConstant: 120).isActive = true
                self.bottomPanelViewHeightConstraint = self.bottomPanelView.heightAnchor.constraint(equalToConstant: 100)
                self.bottomPanelViewHeightConstraint.isActive = true
            } else {
                self.navigationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.bottomPanelViewHeightConstraint = self.bottomPanelView.heightAnchor.constraint(equalToConstant: 70)
                self.bottomPanelViewHeightConstraint.isActive = true
            }
            
            self.bottomPanelView.lblTotalAmount.text = "₹00"
            self.bottomPanelView.lblParcelSecurityFeeValue.text = "₹00"
            self.bottomPanelView.lblForDeliveryValue.text = "₹00"
        }
        
        if let priceInfo = priceInfo {
            self.updatePriceUI(with: priceInfo)
        }
    }
    
    func updateBottomPanel() {
        
        if UIDevice.current.hasNotch {
            let bottomPanelHeight: CGFloat = 100
            
            self.bottomPanelViewHeightConstraint.constant = bottomPanelHeight + (self.bottomPanelView.isArrowUp ? 0 : 40)
            self.bottomPanelView.createOrderTopConstraint.constant = 20 + (self.bottomPanelView.isArrowUp ? 0 : 40)
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.bottomPanelView.isArrowUp ? self.bottomPanelView.hideFields() : self.bottomPanelView.showFields()
                UIApplication.shared.keyWindow?.layoutIfNeeded()
            }
        } else {
            let bottomPanelHeight: CGFloat = 70
            self.bottomPanelViewHeightConstraint.constant = bottomPanelHeight + (self.bottomPanelView.isArrowUp ? 0 : 40)
            self.bottomPanelView.createOrderTopConstraint.constant = 20 + (self.bottomPanelView.isArrowUp ? 0 : 40)
            
            UIView.animate(withDuration: 0.3) {
                self.bottomPanelView.isArrowUp ? self.bottomPanelView.hideFields() : self.bottomPanelView.showFields()
                UIApplication.shared.keyWindow?.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Action Methods
    @objc func crossBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: title, message: "Do you want to cancel the order?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.delegate?.formDismissal()
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func clearDataBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: title, message: "Do you want to cancel the order?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.formFields = FormFieldModel.getFormFields()
            self.priceInfo = nil
            self.updatePriceUI(with: nil)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func btnAmountClick(_ sender: UIButton) {
        self.bottomPanelView.toggleArrowUI()
        self.updateBottomPanel()
    }
    
    @objc func btnCreateOrderClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        var weight: String?
        var optimizeRoute = false
        var parcelPrice: String?
        var category: Category?
        var couponCode: CouponCodeModel?
        var locations: [VisitLocation] = []
        
        let reviewController = OrderReviewViewController()
        
        self.formFields.forEach { (formField) in
            switch formField.type {
            case .weight:
                weight = (formField.value as? String)
                
                if let weight = weight, weight.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    
                    guard let doubleWeight = Double(weight), doubleWeight > 0 else {
                        self.showAlert(withMsg: "Weight should be in digits and greater then 0")
                        return
                    }
                    
                    reviewController.weight = weight.trimmingCharacters(in: .whitespacesAndNewlines)
                } else {
                    self.showAlert(withMsg: "Please add weight")
                    return
                }
                
                break
            case .pickUpPoint:
                if let location = self.getPickUpDeliveryLocation(formField: formField, type: formField.type) {
                    locations.append(location)
                }
                break
            case .deliveryPoint:
                if let location = self.getPickUpDeliveryLocation(formField: formField, type: formField.type) {
                    locations.append(location)
                }
            case .addDeliveryPoint:
                break
            case .optimizeRoute:
                optimizeRoute = (formField.value as? Bool) ?? false
                break
            case .parcelInfo:
                formField.formSubFields.forEach { (subFormField) in
                    switch subFormField.type {
                    case .parcelType:
                        category = subFormField.value as? Category
                        break
                    case .parcelValue:
                        parcelPrice = subFormField.value as? String
                        break
                    case .promoCode:
                        couponCode = subFormField.value as? CouponCodeModel
                        break
                    default:
                        print("Parcel Info case not found")
                    }
                }
                break
            case .paymentInfo:
                for index in 0..<formField.paymentLocation.count {
                    if formField.paymentLocation[index].isSelected {
                        paymentWillOccurAtIndex = index
                    }
                }
                
                break
            }
        }
        
        if locations.count < 2 {
            self.showAlert(withMsg: "Please select pick and delivery")
            return
        }
        
        if let category = category, category.id != "" {
            reviewController.category = category
        } else {
            self.showAlert(withMsg: "Please select parcel category")
            return
        }
        
        if let price = parcelPrice, price.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            reviewController.parcelPrice = price.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.showAlert(withMsg: "Parcel Price not set")
            return
        }
        
        if let price = self.priceInfo {
            reviewController.priceInfo = price
        } else {
            self.showAlert(withMsg: "Price not calculated")
            return
        }
        
        reviewController.coupon = couponCode
        
        reviewController.formDelegate = self.delegate
        reviewController.locations = locations
        reviewController.locations[paymentWillOccurAtIndex].isDefaultPayment = true
        reviewController.optimizeRoute = optimizeRoute
        
        self.navigationController?.pushViewController(reviewController, animated: true)
    }
    
    func getPickUpDeliveryLocation(formField: FormFieldModel, type: FormFieldType) -> VisitLocation? {
        var userName: String!
        var address: AddressModel!
        var date: Date?
        var phoneNo: String!
        var comment: String?
        var storeContactPerson: String?
        var storeContactNo: String?
        var transactionType: String?
        var transactionAmount: String?
        
        var counter = 0
        
        formField.formSubFields.forEach { (subFormField) in
            switch subFormField.type {
            case .address:
                address = (subFormField.value as? AddressModel)
                break
            case .name:
                userName = (subFormField.value as? String) ?? ""
                break
            case .phoneNo:
                phoneNo = (subFormField.value as? String) ?? ""
                break
            case .whenToPickup:
                date = (subFormField.value as? Date) ?? Date()
                break
            case .comment:
                comment = (subFormField.value as? String) ?? ""
                break
            case .contactPerson:
                let value = (subFormField.value as? String) ?? ""
                if value != "" {
                    counter += 1
                }
                counter += 1
                storeContactPerson = value
                break
            case .contactNo:
                let value = (subFormField.value as? String) ?? ""
                if value != "" {
                    counter += 1
                }
                storeContactNo = value
                break
            case .transaction:
                transactionType = (subFormField.value as? (transactionType: String, transactionAmount: String))?.transactionType
                transactionAmount = (subFormField.value as? (transactionType: String, transactionAmount: String))?.transactionAmount
                break
            default:
                print("PickUpDelivery point not handled here")
            }
        }
        
        if address == nil || address!.address == "" {
            self.showAlert(withMsg: "Please select address for \(type == .pickUpPoint ? "Pick up" : "every Delivery")  point")
            return nil
        }
        
        if userName == nil || userName! == "" {
            self.showAlert(withMsg: "Please select user name for \(type == .pickUpPoint ? "Pick up" : "every Delivery") point")
            return nil
        }
        
        if phoneNo == nil || phoneNo! == "" {
            self.showAlert(withMsg: "Please select phone number for \(type == .pickUpPoint ? "Pick up" : "every Delivery") point")
            return nil
        }
        
        //        if date == nil {
        //            self.showAlert(withMsg: "Please select date for every pickUp/Delivery point")
        //            return nil
        //        }
        
        let location = VisitLocation(userName: userName, address: address, dateTime: date ?? Date(), mobileNo: phoneNo, comment: comment ?? "", isDefaultPayment: false)
        location.storeName = storeContactPerson
        location.storeContactNo = storeContactNo
        location.transactionType = transactionType
        location.transactionAmount = transactionAmount
        if counter >= 2 {
            location.orderType = "S"
        } else {
            location.orderType = "N"
        }
        
        return location
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calculateNoOfRows()
    }
    
    func calculateNoOfRows() -> Int {
        self.tableViewFormFields.removeAll()
        
        var count = 0
        var addressFieldCount = 0
        for index in 0..<self.formFields.count {
            let formField = self.formFields[index]
            switch formField.type {
            case .weight, .addDeliveryPoint, .optimizeRoute, .parcelInfo, .paymentInfo:
                count += 1
                self.tableViewFormFields.append(formField)
                break
            case .pickUpPoint, .deliveryPoint:
                addressFieldCount += 1
                count += getCountForAddressFields(formField: formField, isNotDefaultField: addressFieldCount > 2, index: index)
                break
            }
        }
        
        return count
    }
    
    func getCountForAddressFields(formField: FormFieldModel, isNotDefaultField: Bool, index: Int) -> Int {
        var count = 0
        if let headerField = formField.formSubFields.first {
            headerField.parentIndex = index
            if (headerField.value as! Bool) {
                if let storeInfoField = (formField.formSubFields.filter { $0.type == .storeInfoHeader }).first {
                    if (storeInfoField.value as! Bool) {
                        count += formField.formSubFields.count
                        self.tableViewFormFields.append(contentsOf: formField.formSubFields)
                        if isNotDefaultField {
                            let formField = FormSubFieldModel(title: "Remove Address", type: .removeAddress, value: "")
                            formField.parentIndex = index
                            self.tableViewFormFields.append(formField)
                        }
                    } else {
                        count += formField.formSubFields.count - 3
                        self.tableViewFormFields.append(contentsOf: formField.formSubFields)
                        self.tableViewFormFields.removeLast(3)
                        if isNotDefaultField {
                            let formField = FormSubFieldModel(title: "Remove Address", type: .removeAddress, value: "")
                            formField.parentIndex = index
                            self.tableViewFormFields.append(formField)
                        }
                    }
                    
                    if isNotDefaultField {
                        count += 1
                    }
                }
            } else {
                count += 1
                self.tableViewFormFields.append(headerField)
            }
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.tableViewFormFields[indexPath.row]
        if let formField = model as? FormFieldModel {
            switch formField.type {
            case .weight:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WeightTableViewCell.identifier) as? WeightTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(WeightTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.updateData(with: formField)
                
                cell.delegate = self
                
                return cell
            case .pickUpPoint, .deliveryPoint:
                return UITableViewCell()
            case .addDeliveryPoint:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddDeliveryPointTableViewCell.identifier) as? AddDeliveryPointTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(AddDeliveryPointTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                
                return cell
            case .optimizeRoute:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OptimizeRouteTableViewCell.identifier) as? OptimizeRouteTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(OptimizeRouteTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.indexPath = indexPath
                cell.delegate = self
                cell.updateData(with: formField)
                
                return cell
            case .parcelInfo:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ParcelInfoTableViewCell.identifier) as? ParcelInfoTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(ParcelInfoTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.indexPath = indexPath
                cell.delegate = self
                cell.promoCodeDelegate = self
                cell.updateData(with: formField)
                cell.parcelValues = self.parcelCategories
                cell.collectionView.reloadData()
                
                return cell
                //            case .notifyInfo:
                //                guard let cell = tableView.dequeueReusableCell(withIdentifier: NotifyBySMSTableViewCell.identifier) as? NotifyBySMSTableViewCell else {
                //                    assertionFailure("Couldn't dequeue:>> \(NotifyBySMSTableViewCell.identifier)")
                //                    return UITableViewCell()
                //                }
                //
                //                cell.selectionStyle = .none
                //                cell.indexPath = indexPath
                //                cell.delegate = self
                //                cell.updateData(with: formField)
                //
                //                return cell
                
            case .paymentInfo:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentViewTableViewCell.identifier) as? PaymentViewTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(PaymentViewTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.paymentAddressDelegate = self
                cell.selectedIndex = self.paymentWillOccurAtIndex
                cell.updateData(with: formField, allFormFields: self.formFields)
                
                return cell
            }
        } else if let subFormField = model as? FormSubFieldModel {
            
            switch subFormField.type {
            case .header:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressHeaderTableViewCell.identifier) as? AddressHeaderTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(AddressHeaderTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.updateData(with: subFormField)
                cell.model.indexPath = indexPath
                
                return cell
            case .address:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PickAddressFieldTableViewCell.identifier) as? PickAddressFieldTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(PickAddressFieldTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.updateData(with: subFormField)
                cell.model.indexPath = indexPath
                
                return cell
            case .name, .phoneNo, .comment, .contactNo, .contactPerson:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressCommonTableViewCell.identifier, for: indexPath) as? AddressCommonTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(AddressCommonTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.updateData(with: subFormField)
                cell.model.indexPath = indexPath
                
                return cell
            case .whenToPickup:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTimePickerTableViewCell.identifier) as? DateTimePickerTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(DateTimePickerTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.updateData(with: subFormField)
                cell.model.indexPath = indexPath
                
                return cell
            case .storeInfoHeader:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ForOnlineStoreHeaderTableViewCell.identifier) as? ForOnlineStoreHeaderTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(ForOnlineStoreHeaderTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.updateData(with: subFormField)
                cell.model.indexPath = indexPath
                
                return cell
            case .transaction:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTypeTableViewCell.identifier) as? TransactionTypeTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(TransactionTypeTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.updateData(with: subFormField)
                cell.model.indexPath = indexPath
                
                cell.btnTransaction.tag = indexPath.row
                
                cell.btnTransaction.addTarget(self, action: #selector(self.btnTransactionType(sender:)), for: .touchUpInside)
                
                return cell
            case .removeAddress:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RemoveAddressTableViewCell.identifier) as? RemoveAddressTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(RemoveAddressTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.delegate = self
                cell.updateData(with: subFormField)
                cell.model.indexPath = indexPath
                
                return cell
            case .parcelType, .parcelValue, .promoCode:
                // Nothing to do here
                break
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.tableViewFormFields[indexPath.row]
        if let formField = model as? FormFieldModel {
            switch formField.type {
            case .weight:
                return 65
            case .pickUpPoint, .deliveryPoint, .addDeliveryPoint, .optimizeRoute, .parcelInfo:
                return UITableView.automaticDimension
            case .paymentInfo:
                return UITableView.automaticDimension
            }
        } else if let subFormField = model as? FormSubFieldModel {
            switch subFormField.type {
            case .header, .address, .name, .phoneNo, .whenToPickup, .comment, .storeInfoHeader, .contactPerson, .contactNo, .transaction, .removeAddress:
                return UITableView.automaticDimension
            case .parcelType, .parcelValue, .promoCode: //.notifyMeBySMS, .notifyRecipientsBySMS:
                // Flow will never come here
                return 200 // Dummy height if ever comes here we can modify the changes
            }
        }
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.tableViewFormFields[indexPath.row]
        if let subFormField = model as? FormSubFieldModel {
            if subFormField.type == .address {
                self.view.endEditing(true)
                
                let searchAddressController = SearchAddressViewController()
                searchAddressController.indexPath = indexPath
                searchAddressController.delegate = self
                
                if let addressModel = subFormField.value as? AddressModel {
                    searchAddressController.textToSearch = addressModel.address
                }
                self.navigationController?.pushViewController(searchAddressController, animated: true)
            }
        }
    }
    
    @objc func btnTransactionType(sender: UIButton) {
        self.view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.scrollToRow(at: IndexPath(item: sender.tag, section: 0), at: .middle, animated: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.navigationView?.removeFromSuperview()
                self.bottomPanelView?.removeFromSuperview()
                
                if let model = self.tableViewFormFields[sender.tag] as? FormSubFieldModel, model.type == .transaction {
                    let transactionController = TransactonTypeSelectionViewController()
                    transactionController.delegate = self
                    transactionController.topConstraint = self.view.center.y
                    transactionController.indexPath = IndexPath(item: sender.tag, section: 0)
                    
                    transactionController.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.present(transactionController, animated: false, completion: nil)
                }
            }
        }
    }
}

extension NewOrderFormTableViewController: SearchAddressDelegate {
    func previousAddressSelected(userAddressModel: UserAddressModel, indexPath: IndexPath) {
        let model = self.tableViewFormFields[indexPath.row]
        if let subFormField = model as? FormSubFieldModel {
            if subFormField.type == .address {
                subFormField.value = AddressModel(id: "", address: userAddressModel.address, coordinate: CLLocationCoordinate2D(latitude: userAddressModel.latitude, longitude: userAddressModel.longitude))
                let nameIndex = indexPath.row + 1
                let mobileNoIndex = indexPath.row + 2
                
                if let subFormField = self.tableViewFormFields[nameIndex] as? FormSubFieldModel, subFormField.type == .name {
                    subFormField.value = userAddressModel.name
                }
                
                if let subFormField = self.tableViewFormFields[mobileNoIndex] as? FormSubFieldModel, subFormField.type == .phoneNo {
                    subFormField.value = userAddressModel.mobileNo
                }
                
                self.calculatePrice()
                self.tableView.reloadData()
            }
        }
    }
    
    func newLocationPicked(address: AddressModel, indexPath: IndexPath) {
        let model = self.tableViewFormFields[indexPath.row]
        if let subFormField = model as? FormSubFieldModel {
            if subFormField.type == .address {
                subFormField.value = address
                
                self.calculatePrice()
                self.tableView.reloadData()
            }
        }
    }
}

extension NewOrderFormTableViewController: TransactionTypeSelectionDelegate {
    func transactionSelected(indexPath: IndexPath, type: String) {
        self.configureTopBottomUI()
        if type == "" {
            //  Do nothing as nothing selected
        } else {
            if let model = self.tableViewFormFields[indexPath.row] as? FormSubFieldModel, model.type == .transaction {
                model.value = (transactionType: type, transactionAmount: "")
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension NewOrderFormTableViewController: AddDeliveryProtocol {
    func addDeliveryPoint() {
        var index = -1
        for (iteratorIndex, formElement) in self.formFields.enumerated() {
            if formElement.type == .deliveryPoint {
                index = iteratorIndex
            }
        }
        
        let formField = FormFieldModel(title: "Delivery Point", type: .deliveryPoint, formSubFields: FormFieldModel.getDeliveryPointFields(), value: "")
        self.formFields.insert(formField, at: index + 1)
        self.tableView.reloadData()
    }
}

extension NewOrderFormTableViewController {
    func pickDate(previousDate: Date? = nil, completion: @escaping (Date?) -> Void) {
        self.view.endEditing(true)
        
        let picker = DatePickerViewController()
        picker.previousPickedDate = previousDate
        picker.modalPresentationStyle = .overCurrentContext
        picker.datePicked = { (date) in
            completion(date)
        }
        picker.dismissed = {
            completion(nil)
        }
        self.present(picker, animated: false, completion: nil)
    }
    
    func pickLocation(completion: @escaping (AddressModel) -> Void) {
        self.view.endEditing(true)
        
        let pickAddressConstroller = PickAddressViewController()
        pickAddressConstroller.pickAddress = { (addressModel) in
            completion(addressModel)
        }
        self.navigationController?.pushViewController(pickAddressConstroller, animated: true)
    }
}

extension NewOrderFormTableViewController: WeightChangeProtocol {
    func weightChanged(text: String) {
        self.calculatePrice()
    }
}

extension NewOrderFormTableViewController: PaymentSelectedAddressProtocol {
    func paymentAddress(selectedIndex: Int) {
        self.paymentWillOccurAtIndex = selectedIndex
    }
}

// MARK: - AddressField Protocol
extension NewOrderFormTableViewController: AddressHeaderProtocol {
    func arrowActionPerformed(model: FormSubFieldModel) {
        model.value = !(model.value as! Bool)
        self.tableView.reloadData()
    }
}

extension NewOrderFormTableViewController: ForOnLineStoreProtocol {
    func onlineStoreToggle(model: FormSubFieldModel) {
        model.value = !(model.value as! Bool)
        self.tableView.reloadData()
    }
}

extension NewOrderFormTableViewController: PickAddressFieldProtocol {
    func fetchCurrentLocationAction(model: FormSubFieldModel) {
        self.pickLocation { (addressModel) in
            DispatchQueue.main.async {
                model.value = addressModel
                self.calculatePrice()
                self.tableView.reloadRows(at: [model.indexPath], with: .automatic)
            }
        }
    }
}

extension NewOrderFormTableViewController: RemoveAddressProtocol {
    func removeAddress(model: FormSubFieldModel) {
        if let index = model.parentIndex {
            self.formFields.remove(at: index)
            self.calculatePrice()
            self.tableView.reloadData()
        }
    }
}

extension NewOrderFormTableViewController: DatePickerProtocol {
    func datePickerAction(model: FormSubFieldModel) {
        self.navigationView?.removeFromSuperview()
        self.bottomPanelView?.removeFromSuperview()
        
        var fromDate: Date!
        
        self.pickDate { (firstDate) in
            fromDate = firstDate ?? Date()
            
            DispatchQueue.main.async {
                self.configureTopBottomUI()
                model.value = fromDate!
                self.tableView.reloadRows(at: [model.indexPath], with: .automatic)
            }
        }
    }
}

extension NewOrderFormTableViewController: AddressCommonFieldProtocol {
    func tralingActionPerformed(for subFormFieldModel: FormSubFieldModel) {
        switch subFormFieldModel.type {
        case .phoneNo:
            self.contactPicker.delegate = self
            self.phoneNumberField = subFormFieldModel
            self.present(contactPicker, animated: true, completion: nil)
            break
        default:
            assertionFailure("Case not handle in FormSubFieldModel")
        }
    }
}

extension NewOrderFormTableViewController: TransactionTypeDelegate {
    func transactionTypeAction(sender: UIButton, model: FormSubFieldModel) {
        // Perform transactions
    }
}

// MARK: - Contact Picker
extension NewOrderFormTableViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumberCount = contact.phoneNumbers.count
        
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }
        
        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
            
        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
            
            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                    alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
                alert -> Void in
                
            })
            alertController.addAction(cancelAction)
            
            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setNumberFromContact(contactNumber: String) {
        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        contactNumber = String(contactNumber.filter { !" \n\t\r".contains($0) })
        guard contactNumber.count >= 10 else {
            dismiss(animated: true) {
                self.showAlert(withMsg: "Selected contact does not have a valid number")
            }
            return
        }
        
        if let phoneNoField = self.phoneNumberField {
            phoneNoField.value  = String(contactNumber.suffix(10))
            self.tableView.reloadRows(at: [phoneNoField.indexPath], with: .automatic)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}

extension NewOrderFormTableViewController: ReloadCellProtocol {
    func reloadCell(for indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension NewOrderFormTableViewController: ApplyPromoProtocol {
    func didTogglePromoCode(model: CouponCodeModel) {
        if let info = priceInfo {
            self.updatePriceUI(with: info)
        }
        self.tableView.reloadData()
    }
    
    func didSelectCategory(category: Category) {
        self.formFields.forEach { (formField) in
            if formField.type == .parcelInfo {
                formField.formSubFields.forEach { (subFormField) in
                    if subFormField.type == .parcelType {
                        subFormField.value = category
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        self.calculatePrice()
    }
    
    func calculatePrice() {
        var weight: String!
        var category: Category!
        var pickUpCoordinate: CLLocationCoordinate2D!
        var deliveryCoordinates: [CLLocationCoordinate2D]!
        self.formFields.forEach { (formField) in
            
            if formField.type == .weight {
                weight = formField.value as? String
            } else if formField.type == .pickUpPoint {
                formField.formSubFields.forEach { (subFormField) in
                    if subFormField.type == .address {
                        if let addressModel = subFormField.value as? AddressModel, addressModel.address != "" {
                            pickUpCoordinate = addressModel.coordinate
                        }
                    }
                }
            } else if formField.type == .deliveryPoint {
                formField.formSubFields.forEach { (subFormField) in
                    if subFormField.type == .address {
                        if deliveryCoordinates == nil {
                            deliveryCoordinates = []
                        }
                        
                        if let addressModel = subFormField.value as? AddressModel, addressModel.address != "" {
                            deliveryCoordinates.append(addressModel.coordinate)
                        }
                    }
                }
            }
        }
        
        self.formFields.forEach { (formField) in
            if formField.type == .parcelInfo {
                formField.formSubFields.forEach { (subFormField) in
                    if subFormField.type == .parcelType {
                        category = subFormField.value as? Category
                    }
                }
            }
        }
        
        if weight != nil && category != nil && pickUpCoordinate != nil && deliveryCoordinates != nil {
            if weight != "" && category.id != "" && !deliveryCoordinates.isEmpty {
                
                guard let doubleWeight = Double(weight), doubleWeight > 0 else {
                    self.showAlert(withMsg: "Weight should be in digits and greater then 0")
                    return
                }
                
                self.fetchPrice(weight: weight, categoryId: category.id, pickUpCoordinate: pickUpCoordinate, deliveryCoordinates: deliveryCoordinates) { (priceInfo, apiStatus) in
                    DispatchQueue.main.async {
                        if let priceInfo = priceInfo {
                            self.updatePriceUI(with: priceInfo)
                        } else {
                            self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                        }
                    }
                }
            }
        }
    }
    
    func updatePriceUI(with priceInfo: PriceInfo?) {
        self.priceInfo = priceInfo
        
        var couponCode: CouponCodeModel?
        self.formFields.forEach { (formField) in
            switch formField.type {
            case .parcelInfo:
                formField.formSubFields.forEach { (subFormField) in
                    switch subFormField.type {
                    case .promoCode:
                        couponCode = subFormField.value as? CouponCodeModel
                        break
                    default:
                        print("Parcel Info case not found")
                    }
                }
                break
            default:
                print("nothing here")
            }
        }
        
        if let coupon = couponCode, coupon.shouldApplyDiscount {
            let price = (Double(priceInfo?.totalCost ?? "0") ?? 0) - coupon.discount
            self.bottomPanelView.lblTotalAmount.text = "₹\(price)"
        } else {
            self.bottomPanelView.lblTotalAmount.text = "₹\(priceInfo?.totalCost ?? "")"
        }
        self.bottomPanelView.lblParcelSecurityFeeValue.text = "₹\(priceInfo?.insuranceCost ?? "")"
        self.bottomPanelView.lblForDeliveryValue.text = "₹\(priceInfo?.insuranceCost ?? "")"
    }
    
    func applyPromo(model: CouponCodeModel, code: String) {
        print("promoCode:>>\(code)")
        self.view.endEditing(true)
        
        if code == "" {
            model.couponCode = ""
            model.couponId = ""
            model.discount = 0
            self.tableView.reloadData()
            
            if let priceInfo = self.priceInfo {
                self.updatePriceUI(with: priceInfo)
            }
            
        } else {
            
            if let priceInfo = self.priceInfo {
                self.alertLoader = self.showAlertLoader()
                self.applyPromoCode(code: code, amount: self.priceInfo?.totalCost ?? "") { (couponCode, apiStatus) in
                    
                    DispatchQueue.main.async {
                        self.alertLoader?.dismiss(animated: true, completion: nil)
                        print("Coupon code:>> \(String(describing: couponCode?.couponCode))")
                        if couponCode != nil {
                            model.couponCode = couponCode?.couponCode ?? ""
                            model.couponId = couponCode?.couponId ?? ""
                            model.discount = couponCode?.discount ?? 0
                            self.updatePriceUI(with: priceInfo)
                            self.tableView.reloadData()
                        } else {
                            self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong.")
                        }
                    }
                }
            } else {
                self.showAlert(withMsg: "Price not calculated")
            }
        }
    }
}

// MARK: - API Methods
extension NewOrderFormTableViewController {
    func applyPromoCode(code: String, amount: String, completion: @escaping (CouponCodeModel?, APIStatus?) -> Void) {
        if UserConstant.shared.userModel == nil {
            return
        }
        
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.redeemCoupon.rawValue,
            Constants.API.key: "4a57f2d2a12525c234690091a6ba53910b99ea9c",
            Constants.API.customerId: UserConstant.shared.userModel.id,
            Constants.API.amount: amount,
            Constants.API.couponCode: code
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData?.first, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let user: CouponCodeModel = try! JSONDecoder().decode(CouponCodeModel.self, from: jsonData)
                    completion(user, apiStatus)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
    
    func fetchParcelCategories(completion: @escaping ([Category]) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.listCategory.rawValue,
            Constants.API.key: "77945ae2ba04d73771d9c5d10cd428eb1095f489",
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (data, error) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: true, completion: nil)
            }
            if let responseData = data {
                if let categoryData = responseData[keyPath: "\(Constants.Response.response).\(Constants.Response.data)"] as? [[String: Any]] {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: categoryData) {
                        
                        let categories: [Category] = try! JSONDecoder().decode([Category].self, from: jsonData)
                        completion(categories)
                    }
                }
            }
        }
    }
    
    func fetchPrice(weight: String, categoryId: String, pickUpCoordinate: CLLocationCoordinate2D, deliveryCoordinates: [CLLocationCoordinate2D],  completion: @escaping (PriceInfo?, APIStatus?) -> Void) {
        let coordinates = (deliveryCoordinates.map { "\($0.latitude),\($0.longitude)" }).joined(separator: "::")
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getPrice.rawValue,
            Constants.API.key: "234039b43a8652db154f669ddf87a78d6c54a6b2",
            Constants.API.categoryId: categoryId,
            Constants.API.weight: weight,
            Constants.API.pickUpPoint: "\(pickUpCoordinate.latitude),\(pickUpCoordinate.longitude)",
            Constants.API.deliveryPoint: coordinates,
            Constants.API.optimizeRoute: "N"
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (data, error) in
            APIManager.shared.parseResponse(responseData: data) { (responseData, apiStatus) in
                if let response = responseData?.first, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let priceInfo: PriceInfo = try! JSONDecoder().decode(PriceInfo.self, from: jsonData)
                    completion(priceInfo, apiStatus)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
}
