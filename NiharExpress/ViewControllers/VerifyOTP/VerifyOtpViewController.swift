//
//  VerifyOtpViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/6/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol OTPVerifiedProtocol {
    func loginSuccess()
    func registrationSuccess()
    func resendOTP()
}

class VerifyOtpViewController: UIViewController {
    
    var counter: Int!
    
    var otp: String!
    var mobileNoOrEmail: String!
    
    var fullName: String!
    var phoneNumber: String!
    var emailId: String!
    
    var isLoginAPI: Bool!
    
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblRequestTime: UILabel!
    
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnResendOTP: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtOTPField: UITextField!
    
    var timer: Timer?
    var delegate: OTPVerifiedProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    func configureUI() {
        self.activityIndicator.isHidden = true
        self.txtOTPField.text = self.otp
        
        self.btnResendOTP.isHidden = true
        
        if self.isLoginAPI {
            self.lblMobileNo.text = self.mobileNoOrEmail
        } else {
            self.lblMobileNo.text = self.phoneNumber
        }
        
        self.counter = 30
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
        self.btnCross.setTitle(AppIcons.cross.rawValue, for: .normal)
        self.btnCross.setTitleColor(ColorConstant.themePrimary.color, for: .normal)
        self.btnCross.titleLabel?.font = FontUtility.niharExpress(size: 12)
    }
    
    @objc func updateCounter() {
        self.lblRequestTime.textColor = UIColor.gray
        if counter > 0 {
            counter -= 1
            self.lblRequestTime.text = "You may request again in " + String(format: "%02d", counter) + " seconds"
        } else {
            timer?.invalidate()
            timer = nil
            self.btnResendOTP.isHidden = false
            self.lblRequestTime.isHidden = true
        }
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.isLoginAPI {
            self.loginData(with: self.mobileNoOrEmail, verifyOtp: self.otp)
        } else {
            self.registerData(with: self.fullName, phoneNumber: self.phoneNumber, emailId: self.emailId, verifyOtp: self.otp)
        }
    }
    
    @IBAction func btnResendOTP(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.delegate?.resendOTP()
        }
    }
    
    @IBAction func closePanelAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension VerifyOtpViewController {
    func loginData(with mobileNoOrEmail: String, verifyOtp: String) {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.hitLogin(with: mobileNoOrEmail, verifyOtp: verifyOtp) { (user, apiStatus) in
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                if let user = user {
                    UserConstant.shared.userModel = user
                    self.dismiss(animated: false, completion: {
                        self.delegate?.loginSuccess()
                    })
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.lblRequestTime.text = apiStatus?.message ?? "Something went wrong."
                    self.lblRequestTime.textColor = UIColor.red
                }
            }
        }
    }
    
    func registerData(with fullName: String, phoneNumber: String, emailId: String, verifyOtp: String) {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.hitRegister(with: fullName, phoneNumber: phoneNumber, emailId: emailId, verifyOtp: verifyOtp) { (user, apiStatus) in
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                if let user = user {
                    UserConstant.shared.userModel = user
                    self.dismiss(animated: false, completion: {
                        self.delegate?.registrationSuccess()
                    })
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.lblRequestTime.text = apiStatus?.message ?? "Something went wrong."
                    self.lblRequestTime.textColor = UIColor.red
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
    
    func hitRegister(with fullName: String, phoneNumber: String, emailId: String, verifyOtp: String, completion: @escaping (User?, APIStatus?) -> Void) {
        
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.registration.rawValue,
            Constants.API.key: "b237eef2e56a018d0cf46f7749a5f0ceca9e4529",
            Constants.API.name: fullName,
            Constants.API.mobileNo: phoneNumber,
            Constants.API.emaildId: emailId,
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

extension VerifyOtpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.otp = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
