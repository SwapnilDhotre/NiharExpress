//
//  OrdersViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var lblLoginButton: DesignableButton!
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var createOrderButton: DesignableButton!
    @IBOutlet weak var lblOrderWithNoOrganization: UILabel!
    
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var createOrderTopConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.resetAnimatedView()
        self.showAndUpdateNavigationBar(with: "SAME DAY DELIVERY PARTNER", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performShowAnimation()
    }
    
    // MARK: - ToDo Methods
    func configureUI() {
        self.createOrderButton.setImage(FontUtility.appImageIcon(code: AppIcons.edit.rawValue, textColor: .white, size: CGSize(width: 16, height: 16)), for: .normal)
    }
    
    func resetAnimatedView() {
        self.logoHeightConstraint.constant = 90
        self.logoWidthConstraint.constant = 90
        
        self.createOrderTopConstraint.constant = 200
        self.createOrderButton.alpha = 0
        self.lblOrderWithNoOrganization.alpha = 0
    }
    
    func performShowAnimation() {
        self.logoHeightConstraint.constant = 250
        self.logoWidthConstraint.constant = 250
        
        self.createOrderTopConstraint.constant = 80
        
        UIView.animate(withDuration: 1.0, animations: {
            self.createOrderButton.alpha = 1
            self.lblOrderWithNoOrganization.alpha = 1
            self.view.layoutIfNeeded()
        }) { (animated) in }
    }
    
    // MARK: - Action Methods
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Action Methods
    @IBAction func loginBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
}
