//
//  StatisticsViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 21/10/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    var alertLoader: UIAlertController?
    
    @IBOutlet weak var lblTotalNoOrders: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalPaymentAmt: UILabel!
    @IBOutlet weak var lblAveragePaymentAmt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showAndUpdateNavigationBar(with: "Statistics", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
        
        self.getStatics { (data, apiStatus) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                if let data = data {
                let totalOrders = (data["total_order"] as? String) ?? "0";
                let totalPrice = (data["total_price"] as? String) ?? "0";
                let averageAddrPrice = (data["average_price_address"] as? String) ?? "0";
                let averagePrice = (data["average_price"] as? String) ?? "0";

                self.lblTotalNoOrders.text = totalOrders
                self.lblTotalPrice.text = totalPrice
                self.lblTotalPaymentAmt.text = averagePrice
                self.lblAveragePaymentAmt.text = averageAddrPrice
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                }
            }
        }
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    func getStatics(completion: @escaping ([String: Any]?, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getStatistics.rawValue,
            Constants.API.key: "65ddfb2d2002170fab5a78e74da6701a0bc8fb22",
            Constants.API.customerId: UserConstant.shared.userModel.id
        ]
        
        self.alertLoader = self.showAlertLoader()
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (response, apiStatus) in
                if let data = response?.first {
                    completion(data, nil)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }

}
