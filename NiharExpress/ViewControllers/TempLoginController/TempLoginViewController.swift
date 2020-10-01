//
//  TempLoginViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 27/09/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol TempLoginProtocol {
    func loginSuccess(user: User)
    func backPressed()
}

class TempLoginViewController: UIViewController {
    var titleString: String!
    var mobileNo: String!
    
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var txtOTPField: UITextField!
    @IBOutlet weak var otpTimeTicker: UILabel!
    @IBOutlet weak var btnResendOTP: UIButton!
    
    var counter: Int!
    var timer: Timer?
    
    var alertLoader: UIAlertController?
    var delegate: TempLoginProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showAndUpdateNavigationBar(with: self.titleString, withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnPressed(_:)))
        
        self.configureUI()
    }
    
    func configureUI() {
        self.lblPhoneNo.text = self.mobileNo
        
        self.counter = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
        self.btnResendOTP.isHidden = true
        self.alertLoader = self.showAlertLoader()
        self.hitGetOTP(with: self.mobileNo) { (otpValue, apiStatus) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                if let status = apiStatus {
                    self.showAlert(withMsg: status.message)
                } else {
                    self.txtOTPField.text = otpValue
                }
            }
        }
    }
    
    @objc func updateCounter() {
        self.otpTimeTicker.textColor = UIColor.gray
        if counter > 0 {
            counter -= 1
            self.otpTimeTicker.text = "You may request again in " + String(format: "%02d", counter) + " seconds"
        } else {
            timer?.invalidate()
            timer = nil
            self.btnResendOTP.isHidden = false
            self.otpTimeTicker.isHidden = true
        }
    }
    
    // MARK: - Action Methods
    @IBAction func resendOTPAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.configureUI()
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let otp = self.txtOTPField.text!
        
        self.alertLoader = self.showAlertLoader()
        self.hitLogin(with: self.mobileNo, verifyOtp: otp) { (user, apiStatus) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                if let user = user {
                     self.delegate?.loginSuccess(user: user)
                    self.dismiss(animated: false, completion: nil)
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.otpTimeTicker.text = apiStatus?.message ?? "Something went wrong."
                    self.otpTimeTicker.textColor = UIColor.red
                }
            }
        }
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.delegate?.backPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API Methods
    func hitGetOTP(with mobileNoEmail: String, completion: @escaping (String, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getOTP.rawValue,
            Constants.API.key: "6997c339387ac79b5fec7676cd6170b0d8b1e79c",
            Constants.API.mobileNo: mobileNoEmail,
            Constants.API.mod: "C"
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                
                if let otpText = responseData?.first?[Constants.Response.otp] as? Int {
                    completion("\(otpText)", apiStatus)
                } else {
                    completion("", apiStatus)
                }
            }
        }
    }
    
    func hitLogin(with mobileNoOrEmail: String, verifyOtp: String, completion: @escaping (User?, APIStatus?) -> Void) {
        
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.login.rawValue,
            Constants.API.key: "d92095efa4b0d3bf077416ff5734ec1c013f4267",
            Constants.API.mobileNo: mobileNoOrEmail,
            Constants.API.otp: verifyOtp
        ]
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData?.first, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let user: User = try! JSONDecoder().decode(User.self, from: jsonData)
                    completion(user, apiStatus)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
}
