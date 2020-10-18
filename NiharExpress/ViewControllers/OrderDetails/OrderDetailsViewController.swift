//
//  OrderDetailsViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import CoreLocation

enum OrderStatus {
    case assigned
    case pickUp
    case deliveryInProgress
    case awaiting
    case inProgress
    case completed
}

protocol NewOrderCloningProtocol {
    func cloneOrder(with formField: [FormFieldModel])
}

class OrderDetailsViewController: UIViewController {
    
    var order: Order!
    var orderStatus: OrderStatus = .awaiting
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerViewTitle: UILabel!
    @IBOutlet weak var bannerView: UIView!
    
    var addressViews: [OrderAddress] = []
    
    var alertLoader: UIAlertController?
    var delegate: NewOrderCloningProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch self.orderStatus {
            
        case .awaiting, .assigned, .pickUp, .deliveryInProgress:
            self.bannerViewTitle.text = self.order.orderStatus
            self.bannerView.backgroundColor = ColorConstant.orderDetailsActiveBanner.color
        case .inProgress:
            self.bannerViewTitle.text = self.order.orderStatus
            self.bannerView.backgroundColor = ColorConstant.orderDetailsActiveBanner.color
        case .completed:
            self.bannerViewTitle.text = "\(self.order.orderStatus) \(self.order.orderDate.toString(withFormat: "MMM dd, yyyy"))"
            self.bannerView.backgroundColor = UIColor.darkGray
        }
        
        self.showAndUpdateNavigationBar(with: "Order \(order.orderNo)", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnPressed(_:)))
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureUI() {
        self.order.pickUp.orderStatusType = .pickUp
        self.addressViews.append(self.order.pickUp)
        
        self.order.delivery.forEach { (order) in
            order.orderStatusType = .delivery
        }
        self.addressViews.append(contentsOf: self.order.delivery)
        
        self.addressViews.first?.isFirstCell = true
        self.addressViews.last?.isLastCell = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: OrderDetailsLocationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderDetailsLocationTableViewCell.identifier)
        self.tableView.register(UINib(nibName: InformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InformationTableViewCell.identifier)
        self.tableView.register(UINib(nibName: OrderDeliveredTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderDeliveredTableViewCell.identifier)
        self.tableView.register(UINib(nibName: InProgressTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InProgressTableViewCell.identifier)
        self.tableView.register(UINib(nibName: TrackOrderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TrackOrderTableViewCell.identifier)
    }
    
    // MARK: - Action Methods
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension OrderDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressViews.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            switch self.orderStatus {
            case .awaiting:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressTableViewCell.identifier) as? InProgressTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(InProgressTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.updateData(with: self.order)
                cell.delegate = self
                
                return cell
            case .assigned, .pickUp, .deliveryInProgress:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackOrderTableViewCell.identifier) as? TrackOrderTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(TrackOrderTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.updateData(with: self.order)
                cell.delegate = self
                
                return cell
            case .inProgress:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackOrderTableViewCell.identifier) as? TrackOrderTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(TrackOrderTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.updateData(with: self.order)
                cell.delegate = self
                
                return cell
            case .completed:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDeliveredTableViewCell.identifier) as? OrderDeliveredTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(OrderDeliveredTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.updateData(with: self.order)
                cell.delegate = self
                
                return cell
            }
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier) as? InformationTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(InformationTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.updateData(wtih: self.order)
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailsLocationTableViewCell.identifier) as? OrderDetailsLocationTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(OrderDetailsLocationTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            let address = self.addressViews[indexPath.row - 2]
            cell.updateData(with: address, isDelivered: self.orderStatus == .completed)
            cell.selectionStyle = .none
            
            cell.lblCounter.text = "\(indexPath.row - 1)"
            
            cell.isFirst = address.isFirstCell
            cell.isLast = address.isLastCell
            
            return cell
        }
    }
    
    func createClone(of order: Order) {
        var formFields = FormFieldModel.getFormFields()
        
        for _ in 1..<order.delivery.count {
            self.addDeliveryPoint(formFields: &formFields)
        }
        
        var currentDeliveryIndex = 0
        
        for formField in formFields {
            switch formField.type {
            case .weight:
                formField.value = order.weight
            case .pickUpPoint:
                self.addPointsData(to: formField, orderAddress: order.pickUp)
                break
            case .deliveryPoint:
                let orderAddress = order.delivery[currentDeliveryIndex]
                currentDeliveryIndex += 1
                self.addPointsData(to: formField, orderAddress: orderAddress)
                
                break
            case .addDeliveryPoint:
                break
            case .optimizeRoute:
                break
            case .parcelInfo:
                self.addParcelInfo(to: formField, order: order)
            case .paymentInfo:
                break
            }
        }
        
        self.delegate?.cloneOrder(with: formFields)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addDeliveryPoint(formFields: inout [FormFieldModel]) {
        var index = -1
        for (iteratorIndex, formElement) in formFields.enumerated() {
            if formElement.type == .deliveryPoint {
                index = iteratorIndex
            }
        }
        
        let formField = FormFieldModel(title: "Delivery Point", type: .deliveryPoint, formSubFields: FormFieldModel.getDeliveryPointFields(), value: "")
        formFields.insert(formField, at: index + 1)
    }
    
    func addPointsData(to formField: FormFieldModel, orderAddress: OrderAddress) {
        for subFormField in formField.formSubFields {
            switch subFormField.type {
            case .header:
                // Nothing
                break
            case .address:
                let lat = NSString(string: orderAddress.lat).doubleValue
                let long = NSString(string: orderAddress.long).doubleValue
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let addressModel = AddressModel(id: "", address: orderAddress.address, coordinate: coordinate)
                
                subFormField.value = addressModel
                break
            case .name:
                subFormField.value = orderAddress.userName
                break
            case .phoneNo:
                subFormField.value = orderAddress.mobileNo
                break
            case .whenToPickup:
                subFormField.value = Date()
                break
            case .comment:
                subFormField.value = orderAddress.comment
                break
            case .storeInfoHeader:
                break
            case .contactPerson:
                subFormField.value = orderAddress.storeName ?? ""
                break
            case .contactNo:
                subFormField.value = orderAddress.storeContactNo ?? ""
                break
            case .transaction:
                subFormField.value = (transactionType: orderAddress.transactionType ?? "", transactionAmount: "")
                break
            case .removeAddress, .parcelType, .parcelValue, .promoCode:
                break
            }
        }
    }
    
    func addParcelInfo(to formField: FormFieldModel, order: Order) {
        for subFormField in formField.formSubFields {
            switch subFormField.type {
            case .header, .address, .name, .phoneNo, .whenToPickup, .comment, .storeInfoHeader, .contactPerson, .contactNo, .transaction,  .removeAddress:
                break
            case .parcelType:
                subFormField.value = Category(id: "", title: self.order.parcelType, isSelected: false)
                break
            case .parcelValue:
                subFormField.value = order.parcelValue
                break
            case .promoCode:
                subFormField.value = ""
                break
            }
        }
    }
}

extension OrderDetailsViewController: OrderDeliveredProtocol {
    func cloneAction() {
        self.createClone(of: self.order)
    }
    
    func starAction() {
        let starRatingController = StarRatingViewController()
        starRatingController.modalPresentationStyle = .overCurrentContext
        starRatingController.order = self.order
        self.present(starRatingController, animated: false, completion: nil)
    }
}

extension OrderDetailsViewController: InProgressOrderProtocol {
    func modifyOrder() {
        self.createClone(of: self.order)
    }
    
    func cloneOrder() {
        self.createClone(of: self.order)
    }
    
    func cancelOrder() {
        let cancelOrderController = CancellationOrderViewController()
        cancelOrderController.modalPresentationStyle = .overCurrentContext
        cancelOrderController.order = self.order
        
        cancelOrderController.cancelOrderSuccess = {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.present(cancelOrderController, animated: false, completion: nil)
    }
}

extension OrderDetailsViewController: TrackOrderProtocol {
    func fetchTrackLocation(completion: @escaping ((DriverInfo?, [MapLocation]?, APIStatus?) -> Void)) {
        
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getTrackingLocation.rawValue,
            Constants.API.key: "49db3f1b61451f7a7339ca4adeae4b5d7eee9db1",
            Constants.API.orderId: self.order.orderId,
            "user_id": UserConstant.shared.userModel.id,
            "type": "C"
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData?.first {
                    var driverInfo: DriverInfo?
                    var models: [MapLocation] = []
                    
                    if let driverData = response["driver_data"] as? [String: Any], let driverJsonData = try? JSONSerialization.data(withJSONObject: driverData) {
                        if let driverData = try? JSONDecoder().decode(DriverInfo.self, from: driverJsonData) {
                            driverInfo = driverData
                        }
                    }
                    
                    if let pickUpLocation = response["pickup_address"] as? [String: Any], let pickUpJsonData = try? JSONSerialization.data(withJSONObject: pickUpLocation) {
                        models.append(try! JSONDecoder().decode(MapLocation.self, from: pickUpJsonData))
                    }
                    
                    if let deliveryLocations = response["delivery_address"] as? [[String: Any]], let deliveryJsonData = try? JSONSerialization.data(withJSONObject: deliveryLocations) {
                        models.append(contentsOf: try! JSONDecoder().decode([MapLocation].self, from: deliveryJsonData))
                    }
                    
                    completion(driverInfo, models,  nil)
                } else {
                    completion(nil, nil, apiStatus)
                }
            }
        }
    }
    
    func trackOrderAction() {
        
        self.alertLoader = self.showAlertLoader()
        self.fetchTrackLocation { (driverInfo, locations, apiStatus) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                if let locationsData = locations, !locationsData.isEmpty {
                    self.navigateToTrackOrder(with: driverInfo, locations: locations ?? [])
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong!!")
                }
            }
        }
    }
    
    func navigateToTrackOrder(with driverInfo: DriverInfo?, locations: [MapLocation]) {
        let trackOrderController = TrackOrderViewController()
        trackOrderController.order = self.order
        trackOrderController.mapLocations = locations
        self.navigationController?.pushViewController(trackOrderController, animated: true)
    }
}


enum LocationType: String, Codable {
    case pickUp = "P"
    case delivery = "D"
}

class MapLocation: Codable {
    var name: String
    var mobileNo: String
    var address: String
    var type: LocationType
    var coordinate: CLLocationCoordinate2D
    var isComplete: Bool
    
    init(name: String, mobileNo: String, address: String, type: LocationType, coordinate: CLLocationCoordinate2D, isComplete: Bool) {
        self.name = name
        self.mobileNo = mobileNo
        self.address = address
        self.type = type
        self.coordinate = coordinate
        self.isComplete = isComplete
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case mobileNo = "mobile_no"
        case address = "address"
        case type = "type"
        case lat = "latitude"
        case long = "longitude"
        case isComplete = "is_complete"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name: String = try container.decode(String.self, forKey: .name)
        let mobileNo: String = try container.decode(String.self, forKey: .mobileNo)
        let address: String = try container.decode(String.self, forKey: .address)
        let type: LocationType = LocationType(rawValue: try container.decode(String.self, forKey: .type))!
        let latitude: Double = NSString(string: (try? container.decode(String.self, forKey: .lat)) ?? "0").doubleValue
        let longitude: Double = NSString(string: (try? container.decode(String.self, forKey: .long)) ?? "0").doubleValue
        let isComplete: Bool = (try container.decode(String.self, forKey: .isComplete)) == "N" ? false : true
        
        self.init(name: name, mobileNo: mobileNo, address: address, type: type, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), isComplete: isComplete)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.mobileNo, forKey: .mobileNo)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.type, forKey: .type)
        try container.encode("\(self.coordinate.latitude)", forKey: .lat)
        try container.encode("\(self.coordinate.longitude)", forKey: .long)
        try container.encode(self.isComplete ? "S" : "N", forKey: .isComplete)
    }
}
