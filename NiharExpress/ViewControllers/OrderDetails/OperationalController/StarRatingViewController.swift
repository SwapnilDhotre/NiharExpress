//
//  StarRatingViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import Cosmos

class StarRatingViewController: UIViewController {
    
    var order: Order!
    
    @IBOutlet weak var lblRatingTitle: UILabel!
    @IBOutlet weak var lblOverallRating: UILabel!
    @IBOutlet weak var lblDriverRating: UILabel!
    
    @IBOutlet weak var overallRatingView: CosmosView!
    @IBOutlet weak var driverRatingView: CosmosView!
    @IBOutlet weak var crossBtn: UIButton!
    
    var overallRating: Double = 0
    var driverRating: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overallRatingView.didFinishTouchingCosmos = { rating in
            self.overallRating = rating
        }
        
        self.driverRatingView.didFinishTouchingCosmos = { rating in
            self.driverRating = rating
        }
        
        self.configureUI()
    }
    
    func configureUI() {
        self.crossBtn.titleLabel?.font = FontUtility.niharExpress(size: 12)
        self.crossBtn.setTitle(AppIcons.cross.rawValue, for: .normal)
        self.crossBtn.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveRating(_ sender: UIButton) {
        self.saveRating(orderId: self.order.orderId, overallRating: self.overallRating, driverRating: self.driverRating) { (isSucceded, apiStatus) in
            DispatchQueue.main.async {
                if isSucceded {
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                }
            }
        }
    }
    
    func saveRating(orderId: String, overallRating: Double, driverRating: Double, completion: @escaping (Bool, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.orderRating.rawValue,
            Constants.API.key: "416223944cf208b2b71caa590aac54d715585ca7",
            Constants.API.orderId: orderId,
            Constants.API.overAllRating: "\(overallRating)",
            Constants.API.driverRating: "\(driverRating)"
        ]
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let status = apiStatus, status == .success {
                    completion(true, apiStatus)
                } else {
                    completion(false, apiStatus)
                }
            }
        }
    }
}
