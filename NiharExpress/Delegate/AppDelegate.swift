//
//  AppDelegate.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        UserConstant.shared.fetchRequiredConstants()
        
        Util.setIntialController(window: self.window!)
        
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        
        GMSServices.provideAPIKey("AIzaSyCaAqBQK94LMz7gPiEpdqIBAHDoQ0npm_k")//"AIzaSyD0LGElUr4KoKgSbhcxA2SCa2Q6_w-lpf4")
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UserConstant.shared.fetchRequiredConstants()
    }
}

