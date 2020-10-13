//
//  OrderReviewViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class VisitLocation {
    var orderId: String?
    var userName: String
    var address: AddressModel
    var dateTime: Date
    var mobileNo: String
    var comment: String
    var isDefaultPayment: Bool
    var storeName: String?
    var storeContactNo: String?
    var orderType: String?
    var transactionType: String?
    var transactionAmount: String?
    
    init(userName: String, address: AddressModel, dateTime: Date, mobileNo: String, comment: String, isDefaultPayment: Bool) {
        self.userName = userName
        self.address = address
        self.dateTime = dateTime
        self.mobileNo = mobileNo
        self.comment = comment
        self.isDefaultPayment = isDefaultPayment
    }
}

class OrderReviewViewController: UIViewController {
    
    private var isCashOnDelivery: Bool = true
    
    var orderId: String?
    var weight: String!
    var parcelPrice: String!
    var optimizeRoute: Bool!
    var category: Category!
    var priceInfo: PriceInfo!
    var couponId: String = ""
    var locations: [VisitLocation] = []
    
    @IBOutlet weak var lblWhatItem: UILabel!
    @IBOutlet weak var lblItemSize: UILabel!
    @IBOutlet weak var lblItemValue: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var cashOnDeliveryRadio: UILabel!
    @IBOutlet weak var payOnlineRadio: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertLoader: UIAlertController?
    var formDelegate: FormDelegate?
    
    var temporaryUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserConstant.shared.userModel == nil && temporaryUser == nil {
            if let location = self.locations.first {
                let userInfoController = TempLoginViewController()
                userInfoController.mobileNo = location.mobileNo
                userInfoController.titleString = "Phone Verification"
                userInfoController.delegate = self
                
                let navigationController = UINavigationController(rootViewController: userInfoController)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
        self.showAndUpdateNavigationBar(with: "Order Review", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnPressed(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    // MARK: - Custom Methods
    func configureUI() {
        self.lblWhatItem.text = "What's in it : \(category.title)"
        self.lblItemSize.text = "Upto \(weight ?? "")kg, book a courier"
        self.lblItemValue.text = "Stated Value: ₹\(self.priceInfo.totalCost)"
        self.lblTotalAmount.text = "₹\(self.priceInfo.totalCost)"
        
        self.cashOnDeliveryRadio.font = UIFont.fontAwesome(ofSize: 18, style: .regular)
        self.payOnlineRadio.font = UIFont.fontAwesome(ofSize: 18, style: .regular)
        
        self.cashOnDeliveryRadio.textColor = ColorConstant.themePrimary.color
        self.payOnlineRadio.textColor = ColorConstant.themePrimary.color
        
        self.updateRadio()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: ReviewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ReviewTableViewCell.identifier)
    }
    
    func updateRadio() {
        if self.isCashOnDelivery {
            self.cashOnDeliveryRadio.text = FontAwesome.dotCircle.rawValue
            self.payOnlineRadio.text = FontAwesome.circle.rawValue
        } else {
            self.cashOnDeliveryRadio.text = FontAwesome.circle.rawValue
            self.payOnlineRadio.text = FontAwesome.dotCircle.rawValue
        }
    }
    
    // MARK: - Action Methods
    @IBAction func createOrderAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if UserConstant.shared.userModel == nil {
            if self.temporaryUser == nil {
                self.showAlert(withMsg: "User could be registered!!!", title: "Nihar Express") { (alertAction) in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                self.alertLoader = self.showAlertLoader()
                self.createOrder(customerId: self.temporaryUser.id) { (responseData, apiStatus) in
                    DispatchQueue.main.async {
                        self.alertLoader?.dismiss(animated: false, completion: nil)
                        if let _ = responseData {
                            self.formDelegate?.formDismissal()
                            self.dismiss(animated: false, completion: nil)
                        } else {
                            self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong.")
                        }
                    }
                }
            }
        } else {
            self.createOrder { (responseData, apiStatus) in
                DispatchQueue.main.async {
                    self.alertLoader?.dismiss(animated: false, completion: nil)
                    if let _ = responseData {
                        self.formDelegate?.formDismissal()
                        self.dismiss(animated: false, completion: nil)
                    } else {
                        self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong.")
                    }
                }
            }
        }
    }
    
    @IBAction func cashOnDeliveryAction(_ sender: UIButton) {
        self.isCashOnDelivery = true
        self.updateRadio()
    }
    
    @IBAction func payOnlineAction(_ sender: UIButton) {
        self.isCashOnDelivery = false
        self.updateRadio()
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API Methods
    func hitGetOTP(with mobileNoEmail: String, completion: @escaping (String, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getOTP.rawValue,
            Constants.API.key: "6997c339387ac79b5fec7676cd6170b0d8b1e79c",
            Constants.API.mobileNo: mobileNoEmail,
            Constants.API.mod: "W"
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                
                if let customerId = responseData?.first?[Constants.Response.customerId] as? String {
                    completion("\(customerId)", apiStatus)
                } else {
                    completion("", apiStatus)
                }
            }
        }
    }
    
    func createOrder(customerId: String? = nil, completion: @escaping ([String: Any]?, APIStatus?) -> Void) {
        let paymentAtAddress = (self.locations.filter { $0.isDefaultPayment }).first
        
        var array = self.locations
        let pickUpLocation = array.remove(at: 0)
        
        let params: [String: Any] = [
            Constants.API.method: Constants.MethodType.placeOrder.rawValue,
            Constants.API.key: "5b418e652da7ed82fe28897fa81bc0356c7d8f31",
            Constants.API.categoryId: self.category.id,
            Constants.API.weight: self.weight ?? "",
            
            Constants.API.pickUpAddress: pickUpLocation.address.address,
            Constants.API.pickUpPoint: "\(pickUpLocation.address.coordinate.latitude),\(pickUpLocation.address.coordinate.longitude)",
            Constants.API.pickUpName: pickUpLocation.userName,
            Constants.API.pickUpMobile: pickUpLocation.mobileNo,
            Constants.API.pickUpDate: pickUpLocation.dateTime.toString(withFormat: "yyyy-MM-dd"),
            Constants.API.pickUpTime: pickUpLocation.dateTime.toString(withFormat: "hh:mm:a"),
            Constants.API.pickUpComment: pickUpLocation.comment,
            Constants.API.pickUpStoreName: pickUpLocation.storeName ?? "",
            Constants.API.pickUpStoreContactNo: pickUpLocation.storeContactNo ?? "",
            Constants.API.pickUpOrderType: pickUpLocation.orderType ?? "",
            Constants.API.pickUptransactionType: pickUpLocation.transactionType ?? "",
            
            Constants.API.deliveryAddress: (array.map { $0.address.address }).joined(separator: "::"),
            Constants.API.deliveryPoint: (array.map { "\($0.address.coordinate.latitude),\($0.address.coordinate.longitude)" }).joined(separator: "::"),
            Constants.API.deliveryMobile: (array.map { $0.mobileNo }),
            Constants.API.deliveryName: (array.map { $0.userName }),
            Constants.API.deliveryComment: (array.map { $0.comment }),
            Constants.API.deliveryStoreName: (array.map { $0.storeName ?? "" }),
            Constants.API.deliveryStoreContactNo: (array.map { $0.storeContactNo ?? "" }),
            Constants.API.deliveryOrderType: (array.map { $0.orderType ?? "" }),
            Constants.API.deliveryTransactionType: (array.map { $0.transactionType ?? "" }),
            
            Constants.API.orderType: "N",
            Constants.API.price: self.priceInfo.totalCost,
            Constants.API.customerId: customerId ?? UserConstant.shared.userModel.id,
            Constants.API.cityId: UserConstant.shared.city?.id ?? "1",
            Constants.API.paymentMethod: self.isCashOnDelivery ? "CA" : "CO",
            Constants.API.paymentAddress: paymentAtAddress?.address.address ?? "",
            Constants.API.insurancePrice: self.priceInfo.insuranceCost,
            Constants.API.parcelPrice: self.parcelPrice ?? "",
            Constants.API.distance: "\(self.priceInfo.distance)"
        ]
        
        //        Constants.API.orderId: nil,
        //        Constants.API.couponId: nil,
        //        Constants.API.discount: nil,
        
//        params.printPrettyJSON()
        
        var val = createJsonString(parameter: params)
        
        print("jh")
        //        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: ["data":val], headers: nil) { (responseData, error) in
        //           APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
        //                if let data = responseData?.first {
        //                    completion(data, nil)
        //                } else {
        //                    completion(nil, apiStatus)
        //                }
        //            }
        //        }
        
        guard let url = URL(string: URLConstant.baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: Constants.headers.accept)
        request.httpMethod = "POST"
        
        APIManager.shared.executeRequest(urlRequest: request) { (responseData: [String:Any]?, error: Error?) in
            responseData?.printPrettyJSON()
            
            print("fsdf");
            
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let data = responseData?.first {
                    completion(data, nil)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
    
    func createJsonString(parameter dict: [String:Any]) -> String {
        
        if JSONSerialization.isValidJSONObject(dict) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
                
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    return jsonString as String
                }
            } catch let JSONError as NSError {
                print("\(JSONError)")
            }
        }
        return ""
    }
}

extension OrderReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier) as? ReviewTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(ReviewTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        let data = self.locations[indexPath.row]
        cell.updateData(with: "\(indexPath.row + 1)", address: data.address.address, dateTime: data.dateTime.toString(withFormat: "dd-MM-yyyy hh:mm a"), mobileNo: data.mobileNo)
        
        return cell
    }
}

extension OrderReviewViewController: TempLoginProtocol {
    func loginSuccess(user: User) {
        self.temporaryUser = user
        UserConstant.shared.userModel = user
    }
    
    func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
