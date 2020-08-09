//
//  EmptyFormViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/9/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class EmptyFormViewController: UIViewController {

    var doNotExecute: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !doNotExecute {
            let controller = NewOrderFormTableViewController()
            controller.delegate = self
            let formController = UINavigationController(rootViewController: controller)
            formController.modalPresentationStyle = .fullScreen
            self.present(formController, animated: true, completion: nil)
        } else {
            self.doNotExecute = false
            self.tabBarController?.selectedIndex = 0
        }
    }
}


extension EmptyFormViewController: FormDelegate {
    func formDismissal() {
        self.doNotExecute = true
    }
}

