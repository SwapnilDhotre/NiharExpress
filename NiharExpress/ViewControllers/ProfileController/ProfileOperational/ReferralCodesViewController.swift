//
//  ReferralCodesViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 10/4/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class ReferralCodesViewController: UIViewController {
    
    var coupons: [CouponModel] = []
    var alertLoader: UIAlertController?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    func configureUI() {
        self.showAndUpdateNavigationBar(with: "Discount Codes", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
        
        let notificationBarButton = self.addNotificationBarButton(actionController: self, notificationAction: #selector(self.notificationAction(_:)))
        Util.setNotificationCount(btn: notificationBarButton)
        
        self.setUpTableView()
        
        self.fetchReferralCodes { (couponsData, apiStatus) in
            DispatchQueue.main.async {
                if let coupons = couponsData {
                    self.coupons = coupons
                    self.tableView.reloadData()
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                }
            }
        }
    }
    
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: PromoCodeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PromoCodeTableViewCell.identifier)
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notificationAction(_ sender: UIBarButtonItem) {
        let notificationController = NotificationViewController()
        self.navigationController?.pushViewController(notificationController, animated: true)
    }
    
    func fetchReferralCodes(completion: @escaping ([CouponModel]?, APIStatus?) -> Void) {
        
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.listReferenceCoupon.rawValue,
            Constants.API.key: "382d73a6c18bebb39f39767e5c75f7cd872dcc52",
            Constants.API.customerId: UserConstant.shared.userModel.id
        ]
        
        self.alertLoader = self.showAlertLoader()
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                
                DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                if let response = responseData, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let coupons: [CouponModel] = try! JSONDecoder().decode([CouponModel].self, from: jsonData)
                    completion(coupons, apiStatus)
                } else {
                    completion(nil, apiStatus)
                }
                }
            }
        }
    }
}

extension ReferralCodesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PromoCodeTableViewCell.identifier) as? PromoCodeTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(PromoCodeTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none

        cell.lblExpiryDateValue.text = self.coupons[indexPath.row].expiryDate
        cell.lblCouponCodeValue.text = self.coupons[indexPath.row].couponCode
        cell.lblDiscountValue.text = self.coupons[indexPath.row].discount
        cell.lblGeneratedByValue.text = self.coupons[indexPath.row].generatedBy
        cell.lblStatusValue.text = self.coupons[indexPath.row].isUsed ? "Available" : "Not Available"
        
        return cell
    }
}
