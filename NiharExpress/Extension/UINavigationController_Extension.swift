//
//  UINavigationController_Extension.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func pushReplacement(_ viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: animated)
        var controllers = self.viewControllers
        if controllers.count >= 2 {
            controllers.remove(at: controllers.count - 2)
        }
        self.viewControllers = controllers
    }
    
    func popViewController(noOfControllers: Int, animated: Bool) {
        let viewControllers: [UIViewController] = self.viewControllers as [UIViewController]
        self.popToViewController(viewControllers[viewControllers.count - (noOfControllers + 1)], animated: animated)
    }
}
