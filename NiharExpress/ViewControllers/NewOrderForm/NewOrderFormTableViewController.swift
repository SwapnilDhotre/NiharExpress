//
//  NewOrderFormTableViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import CoreLocation

protocol FormDelegate {
    func formDismissal()
}

class NewOrderFormTableViewController: UITableViewController {
    
    var delegate: FormDelegate?
    var navigationView: NavigationView!
    var bottomPanelView: BottomCreateOrderView!
    
    var bottomPanelViewHeightConstraint: NSLayoutConstraint!
    
    var formFields: [FormFieldModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureTopBottomUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationView?.removeFromSuperview()
        self.bottomPanelView?.removeFromSuperview()
    }
    
    // MARK: - To Do Methods
    func configureUI() {
        self.hideNavigationBar()
        self.formFields = FormFieldModel.getFormFields()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let topPadding: CGFloat = 80
        let bottomPadding: CGFloat = 110
        self.tableView.contentInset = UIEdgeInsets.init(top: topPadding, left: 0, bottom: bottomPadding, right: 0)
        
        self.tableView.register(UINib(nibName: WeightTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WeightTableViewCell.identifier)
        self.tableView.register(UINib(nibName: PickUpDeliveryPointTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PickUpDeliveryPointTableViewCell.identifier)
        self.tableView.register(UINib(nibName: AddDeliveryPointTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AddDeliveryPointTableViewCell.identifier)
        self.tableView.register(UINib(nibName: OptimizeRouteTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OptimizeRouteTableViewCell.identifier)
        self.tableView.register(UINib(nibName: NotifyBySMSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotifyBySMSTableViewCell.identifier)
        self.tableView.register(UINib(nibName: ParcelInfoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ParcelInfoTableViewCell.identifier)
        self.tableView.register(UINib(nibName: PaymentViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PaymentViewTableViewCell.identifier)
        
        
    }
    
    func configureTopBottomUI() {
        
        self.navigationView = NavigationView()
        self.bottomPanelView = BottomCreateOrderView()
        
        self.navigationView.leftNavigationButton.addTarget(self, action: #selector(self.crossBtnAction(_:)), for: .touchUpInside)
        self.navigationView.rightNavigationButton.addTarget(self, action: #selector(self.clearDataBtnAction(_:)), for: .touchUpInside)
        self.bottomPanelView.btnAmountClick.addTarget(self, action: #selector(self.btnAmountClick), for: .touchUpInside)
        self.bottomPanelView.btnCreateOrder.addTarget(self, action: #selector(self.btnAmountClick), for: .touchUpInside)
        
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
        self.delegate?.formDismissal()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clearDataBtnAction(_ sender: UIButton) {
        self.formFields.forEach { (formfield) in
            self.setDefaultType(formfield: formfield)
            
            formfield.formSubFields.forEach { (subFormField) in
                self.setDefaultType(formfield: subFormField)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func setDefaultType(formfield: FormFieldModel) {
        if formfield.value is Int {
            formfield.value = 0
        } else if formfield.value is String {
            formfield.value = ""
        } else if formfield.value is Bool {
            formfield.value = false
        } else if formfield.value is Date {
            formfield.value = Date()
        }  else if formfield.value is (Date, Date) {
            formfield.value = (Date(), Date())
        } else if formfield.value is AddressModel {
            formfield.value = AddressModel(address: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        }
    }
    
    func setDefaultType(formfield: FormSubFieldModel) {
        if formfield.value is Int {
            formfield.value = 0
        } else if formfield.value is String {
            formfield.value = ""
        } else if formfield.value is Bool {
            formfield.value = false
        } else if formfield.value is Date {
            formfield.value = Date()
        }  else if formfield.value is (Date, Date) {
            formfield.value = (Date(), Date())
        } else if formfield.value is AddressModel {
            formfield.value = AddressModel(address: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        }
    }
    
    @objc func btnAmountClick(_ sender: UIButton) {
        self.bottomPanelView.toggleArrowUI()
        self.updateBottomPanel()
    }
    
    @objc func btnCreateOrderClick(_ sender: UIButton) {
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formFields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.formFields[indexPath.row].type {
        case .weight:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeightTableViewCell.identifier) as? WeightTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(WeightTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            
            return cell
        case .pickUpPoint, .deliveryPoint:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PickUpDeliveryPointTableViewCell.identifier) as? PickUpDeliveryPointTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(PickUpDeliveryPointTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.delegate = self
            cell.locationCellDelegate = self
            cell.updateData(with: self.formFields[indexPath.row])
            
            return cell
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
            cell.updateData(with: self.formFields[indexPath.row])
            
            return cell
        case .parcelInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ParcelInfoTableViewCell.identifier) as? ParcelInfoTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(NotifyBySMSTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.delegate = self
            cell.promoCodeDelegate = self
            cell.updateData(with: self.formFields[indexPath.row])
            
            return cell
        case .notifyInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotifyBySMSTableViewCell.identifier) as? NotifyBySMSTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(NotifyBySMSTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            cell.delegate = self
            cell.updateData(with: self.formFields[indexPath.row])
            
            return cell
            
        case .paymentInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentViewTableViewCell.identifier) as? PaymentViewTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(PaymentViewTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.updateData(with: self.formFields[indexPath.row], allFormFields: self.formFields)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.formFields[indexPath.row].type {
        case .weight:
            return 65
        case .pickUpPoint:
            return UITableView.automaticDimension
        case .deliveryPoint:
            return UITableView.automaticDimension
        case .addDeliveryPoint:
            return UITableView.automaticDimension
        case .optimizeRoute:
            return UITableView.automaticDimension
        case .parcelInfo:
            return UITableView.automaticDimension
        case .notifyInfo:
            return 120
        case .paymentInfo:
            return UITableView.automaticDimension
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

extension NewOrderFormTableViewController: LocationCellProtocol {
    func showDatePicker(indexPath: IndexPath) {
        
        self.navigationView?.removeFromSuperview()
        self.bottomPanelView?.removeFromSuperview()
        
        var fromDate: Date!
        var toDate: Date!
        
        self.pickDate { (firstDate) in
            fromDate = firstDate ?? Date()
            
            DispatchQueue.main.async {
                self.pickDate { (secondDate) in
                    DispatchQueue.main.async {
                        toDate = secondDate ?? Date()
                        self.configureTopBottomUI()
                        self.reloadTableView(with: fromDate, toDate: toDate, indexPath: indexPath)
                    }
                }
            }
        }
    }
    
    func reloadTableView(with fromDate: Date, toDate: Date, indexPath: IndexPath) {
        if let dateFormModel = (self.formFields[indexPath.row].formSubFields.filter { $0.type == .whenToPickup || $0.type == .whenToDelivery }).first {
            dateFormModel.value = (fromDate, toDate)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.tableView.reloadData()
    }
    
    func pickDate(completion: @escaping (Date?) -> Void) {
        let picker = DatePickerViewController()
        picker.modalPresentationStyle = .overCurrentContext
        picker.datePicked = { (date) in
            completion(date)
        }
        picker.dismissed = {
            completion(nil)
        }
        self.present(picker, animated: false, completion: nil)
    }
    
    func pickLocation(indexPath: IndexPath) {
        let pickAddressConstroller = PickAddressViewController()
        pickAddressConstroller.pickAddress = { (addressModel) in
            if let addressFormModel = (self.formFields[indexPath.row].formSubFields.filter { $0.type == .address }).first {
                addressFormModel.value = addressModel
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        self.navigationController?.pushViewController(pickAddressConstroller, animated: true)
    }
}

extension NewOrderFormTableViewController: ReloadCellProtocol {
    func reloadCell(for indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension NewOrderFormTableViewController: ApplyPromoProtocol {
    func applyPromo(code: String) {
        print("promoCode:>>\(code)")
        self.view.resignFirstResponder()
    }
}
