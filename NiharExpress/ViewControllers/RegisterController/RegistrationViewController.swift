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
}

extension RegistrationViewController: TabbedViewDataSource {
    func tabTitles() -> [String] {
        return [
            "FOR INDVIDUALS",
            "FOR BUSINESS"
        ]
    }
    
    func reloadContainer(for tab: TabModel, index: Int) -> UIView {
        return RegistrationView()
    }
}
