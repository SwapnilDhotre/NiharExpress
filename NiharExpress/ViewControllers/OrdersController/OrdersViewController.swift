//
//  OrdersViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
    }
    
    // MARK: - ToDo Methods
    func configureUI() {
        self.navigationItem.title = "SAME DAY DELIVERY PARTNER"
    }

    // MARK: - Action Methods
    @IBAction func loginBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
}
