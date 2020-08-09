//
//  LoginViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tabbedView: TabbedView!
    
    var loginView: LoginView?
    var alertLoader: UIAlertController?
    
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
        self.showAndUpdateNavigationBar(with: "Sign in", withShadow: false, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
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
    func hitGetOTP(with mobileNoEmail: String, completion: @escaping (String, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getOTP.rawValue,
            Constants.API.key: "6997c339387ac79b5fec7676cd6170b0d8b1e79c",
            Constants.API.mobileNo: mobileNoEmail,
            Constants.API.mod: "L"
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

extension LoginViewController: TabbedViewDataSource {
    func tabTitles() -> [String] {
        return [
            "FOR INDVIDUALS",
            "FOR BUSINESS"
        ]
    }
    
    func reloadContainer(for tab: TabModel, index: Int) -> UIView {
        self.loginView = LoginView()
        self.loginView?.delegate = self
        return loginView!
    }
}

extension LoginViewController: LoginViewProtocol {
    func loginData(with mobileOrEmail: String) {
        let isSuccess = self.verifyData(mobileNoOrEmail: mobileOrEmail)
        if isSuccess {
            self.alertLoader = self.showAlertLoader()
            self.hitGetOTP(with: mobileOrEmail, completion: { (otpValue, apiStatus) in
                
                DispatchQueue.main.async {
                    self.alertLoader?.dismiss(animated: false, completion: nil)
                    if let status = apiStatus {
                        self.showAlert(withMsg: status.message)
                    } else {
                        let verifyController = VerifyOtpViewController()
                        verifyController.mobileNoOrEmail = mobileOrEmail
                        verifyController.otp = otpValue
                        
                        verifyController.isLoginAPI = true
                        verifyController.delegate = self
                        
                        verifyController.modalPresentationStyle = .overCurrentContext
                        self.present(verifyController, animated: false, completion: nil)
                    }
                }
            })
        }
    }
    
    func verifyData(mobileNoOrEmail: String) -> Bool {
        if mobileNoOrEmail == "" {
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

extension LoginViewController: OTPVerifiedProtocol {
    func registrationSuccess() {}
    
    func loginSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resendOTP() {
        self.loginView?.btnRequestOTP.sendActions(for: .touchUpInside)
    }
}

