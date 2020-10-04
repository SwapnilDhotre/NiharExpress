//
//  EditProfileViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 04/10/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var txtFullNameField: UITextField!
    @IBOutlet weak var txtEmailField: UITextField!
    
    var alertLoader: UIAlertController?
    var isSaveAlreadyAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTextFields()
        
        self.showAndUpdateNavigationBar(with: "Profile Details", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
        
        let notificationBarButton = self.addNotificationBarButton(actionController: self, notificationAction: #selector(self.notificationAction(_:)))
        Util.setNotificationCount(btn: notificationBarButton)
    }
    
    func setUpTextFields() {
        self.txtFullNameField.delegate = self
        self.txtEmailField.delegate = self
        
        self.txtFullNameField.text = "\(UserConstant.shared.userModel.firstName) \(UserConstant.shared.userModel.lastName)"
        self.txtEmailField.text = UserConstant.shared.userModel.emailId
        
        self.txtFullNameField.addTarget(self, action: #selector(self.textDidChanged(_:)), for: .editingChanged)
        self.txtEmailField.addTarget(self, action: #selector(self.textDidChanged(_:)), for: .editingChanged)
    }
    
    func addSaveBtn() {
        
        if !isSaveAlreadyAdded {
            self.isSaveAlreadyAdded = true
            let saveBtn = UIButton()
            saveBtn.setTitle("SAVE", for: .normal)
            saveBtn.titleLabel?.font = FontUtility.roboto(style: .Regular, size: 14)
            saveBtn.setTitleColor(ColorConstant.themePrimary.color, for: .normal)
            saveBtn.addTarget(self, action: #selector(self.saveBtnAction(_:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem(customView: saveBtn)
            self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItem!, barButton]
        }
    }
    
    @objc func saveBtnAction(_ sender: UIButton) {
        self.saveEditedProfile()
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notificationAction(_ sender: UIBarButtonItem) {
        let notificationController = NotificationViewController()
        self.navigationController?.pushViewController(notificationController, animated: true)
    }
    
    func saveEditedProfile() {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.editProfile.rawValue,
            Constants.API.key: "cb954a3797065bae4c444456d4fa32f2153ddf3a",
            Constants.API.customerId: UserConstant.shared.userModel.id,
            Constants.API.name: self.txtFullNameField.text,
            Constants.API.emaildId: self.txtEmailField.text,
            Constants.API.mobileNo: UserConstant.shared.userModel.mobileNo
        ]
        
        self.alertLoader = self.showAlertLoader()
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                
                DispatchQueue.main.async {
                    self.alertLoader?.dismiss(animated: false, completion: nil)
                    if let response = responseData?.first, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                        let user = try! JSONDecoder().decode(User.self, from: jsonData)
                        UserConstant.shared.userModel = user
                    }
                }
            }
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    @objc func textDidChanged(_ textfield: UITextField) {
        self.addSaveBtn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
}

