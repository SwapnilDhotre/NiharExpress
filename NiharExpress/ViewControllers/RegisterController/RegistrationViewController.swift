//
//  RegistrationViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var tabbedView: TabbedView!
    
    var registrationView: RegistrationView?
    var alertLoader: UIAlertController?
    
    var delegate: ProfileScreenLoginRegisterDelegate?
        
    // MARK: - Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabbedView.tabbedDatasource = self
        self.tabbedView.reloadTabs()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.showAndUpdateNavigationBar(with: "Register", withShadow: false, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Custom Methods
    func configureUI() {
        
    }
    
    // MARK: - Action Methods
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API MEthods
    func hitGetOTP(with fullName: String, phoneNumber: String, completion: @escaping (String, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getOTP.rawValue,
            Constants.API.key: "6997c339387ac79b5fec7676cd6170b0d8b1e79c",
            Constants.API.mobileNo: phoneNumber,
//            Constants.API.mod: "L"
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
}

extension RegistrationViewController: TabbedViewDataSource {
    func tabTitles() -> [String] {
        return [
            "FOR INDVIDUALS",
            "FOR BUSINESS"
        ]
    }
    
    func reloadContainer(for tab: TabModel, index: Int) -> UIView {
        self.registrationView = RegistrationView()
        self.registrationView?.delegate = self
        return self.registrationView!
    }
}

extension RegistrationViewController: RegistrationViewProtocol {
    func getOTP(with fullName: String, phoneNumber: String, emailId: String) {
        let isSuccess = self.verifyData(fullName: fullName, phoneNumber: phoneNumber)
        if isSuccess {
            self.alertLoader = self.showAlertLoader()
            self.hitGetOTP(with: fullName, phoneNumber: phoneNumber, completion: { (otpValue, apiStatus) in
                
                DispatchQueue.main.async {
                    self.alertLoader?.dismiss(animated: false, completion: nil)
                    if let status = apiStatus {
                        self.showAlert(withMsg: status.message)
                    } else {
                        
                        let verifyOTPController = VerifyOtpViewController()
                        verifyOTPController.fullName = fullName
                        verifyOTPController.phoneNumber = phoneNumber
                        verifyOTPController.emailId = emailId
                        verifyOTPController.otp = otpValue
                        
                        verifyOTPController.isLoginAPI = false
                        verifyOTPController.delegate = self
                        
                        verifyOTPController.modalPresentationStyle = .overCurrentContext
                        
                        self.present(verifyOTPController, animated: false, completion: nil)
                    }
                }
            })
        }
    }
    
    func registerData(with fullName: String, phoneNumber: String, emailId: String) {
        
        let isSuccess = self.verifyData(fullName: fullName, phoneNumber: phoneNumber)
        if isSuccess {
            self.getOTP(with: fullName, phoneNumber: phoneNumber, emailId: emailId)
        }
    }
    
    func verifyData(fullName: String, phoneNumber: String) -> Bool {
        if fullName == "" {
            self.showAlert(with: "Please provide full name.")
            return false
        }
        
        if phoneNumber == "" {
            self.showAlert(with: "Please provide mobile no.")
            return false
        }
        
        return true
    }
    
    func showAlert(with msg: String) {
        var alert: UIAlertController? = nil
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert?.dismiss(animated: true, completion: nil)
        })
        
        alert = self.showAlertAndCustomAction(withMsg: msg, title: "Nihar Express", actions: [defaultAction])
    }
}

extension RegistrationViewController: OTPVerifiedProtocol {
    func loginSuccess() {}
    
    func userAlreadyExist() {
        self.showAlert(with: APIStatus.alreadyExist.message)
    }
    
    func registrationSuccess() {
        self.delegate?.navigateToOrders()
        self.navigationController?.popViewController(animated: true)
    }
    
    func resendOTP() {
        self.registrationView?.btnRegister.sendActions(for: .touchUpInside)
    }
}
