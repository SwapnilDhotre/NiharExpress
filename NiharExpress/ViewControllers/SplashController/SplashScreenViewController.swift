//
//  SplashScreenViewController.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 7/6/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.logoHeightConstraint.constant = 250
        self.logoWidthConstraint.constant = 250
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }) { (animated) in
            self.navigateToRespectiveController()
        }
    }
    
    func navigateToRespectiveController() {
        let tabBarController = TabBarViewController()
        self.navigationController?.pushReplacement(tabBarController, animated: true)
    }
}

