//
//  TabBarViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureTabs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureUI() {
        self.delegate = self
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = ColorConstant.themePrimary.color
        self.tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    func configureTabs() {
        let controller = UIViewController()
        let ordersNavigationController = UINavigationController(rootViewController: OrdersViewController())
        let profileNavigationController = UINavigationController(rootViewController: ProfileViewController())
        let helpController = HelpViewController()
        let infoController = InfoViewController()
        
        self.viewControllers =
            [ordersNavigationController, profileNavigationController, controller, helpController, infoController]
        
        self.selectedViewController = ordersNavigationController
        
        let item1 = UITabBarItem()
        item1.title = "Orders"
        item1.tag = 101
        item1.image = FontUtility.appImageIcon(code: AppIcons.orders.rawValue, textColor: .white, size: CGSize(width: 24, height: 24))
        
        ordersNavigationController.tabBarItem = item1
        
        let item2 = UITabBarItem()
        item2.title = "Profile"
        item2.tag = 102
        item2.image = FontUtility.appImageIcon(code: AppIcons.outlinePerson.rawValue, textColor: .white, size: CGSize(width: 24, height: 24))
        
        profileNavigationController.tabBarItem = item2
        
        let item3 = UITabBarItem()
        item3.title = "New Order"
        item3.tag = 103
        item3.image = FontUtility.appImageIcon(code: AppIcons.outlineAddCircle.rawValue, textColor: .white, size: CGSize(width: 24, height: 24))
        
        controller.tabBarItem = item3
        
        let item4 = UITabBarItem()
        item4.title = "Help"
        item4.tag = 104
        item4.image = FontUtility.appImageIcon(code: AppIcons.outlineHelp.rawValue, textColor: .white, size: CGSize(width: 24, height: 24))
        
        helpController.tabBarItem = item4
        
        let item5 = UITabBarItem()
        item5.title = "Info"
        item4.tag = 105
        item5.image = FontUtility.appImageIcon(code: AppIcons.outlineInfo.rawValue, textColor: .white, size: CGSize(width: 24, height: 24))
        
        infoController.tabBarItem = item5
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 103 {
            let controller = NewOrderFormTableViewController()
            controller.delegate = self
            let formController = UINavigationController(rootViewController: controller)
            formController.modalPresentationStyle = .fullScreen
            self.present(formController, animated: true, completion: nil)
        }
    }
}

extension TabBarViewController: FormDelegate {
    func formDismissal() {
        self.selectedIndex = 0
    }
}
