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
    
    func configureUI() {
        self.delegate = self
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.purple
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
    }
    
    func configureTabs() {
        let controller = UIViewController()
        let ordersController = OrdersViewController()
        let navigationOrders = UINavigationController(rootViewController: ordersController)
        let profileController = ProfileViewController()
        let helpController = HelpViewController()
        let infoController = InfoViewController()
        
        self.viewControllers =
            [navigationOrders, profileController, controller, helpController, infoController]
        
        self.selectedViewController = navigationOrders
        
        let item1 = UITabBarItem()
        item1.title = "Orders"
        item1.image = UIImage(named: "home")
        
        navigationOrders.tabBarItem = item1
        
        let item2 = UITabBarItem()
        item2.title = "Profile"
        item2.image = UIImage(named: "home")
        
        profileController.tabBarItem = item2
        
        let item3 = UITabBarItem()
        item3.title = "New Order"
        item3.tag = 102
        item3.image = UIImage(named: "home")
        
        controller.tabBarItem = item3
        
        let item4 = UITabBarItem()
        item4.title = "Help"
        item4.image = UIImage(named: "home")
        
        helpController.tabBarItem = item4
        
        let item5 = UITabBarItem()
        item5.title = "Info"
        item5.image = UIImage(named: "home")
        
        infoController.tabBarItem = item5
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 102 {
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
