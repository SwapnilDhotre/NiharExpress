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
            
            let barButton = UIBarButtonItem(customView: saveBtn)
            barButton.action = #selector(self.saveBtnAction(_:))
            self.navigationItem.rightBarButtonItems = [self.navigationItem.rightBarButtonItem!, barButton]
        }
    }
    
    @objc func saveBtnAction(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notificationAction(_ sender: UIBarButtonItem) {
        let notificationController = NotificationViewController()
        self.navigationController?.pushViewController(notificationController, animated: true)
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

