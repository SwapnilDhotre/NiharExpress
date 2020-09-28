//
//  AppDelegate.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

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
        
        UITextViewWorkaround.unique.executeWorkaround()
        
        GMSServices.provideAPIKey(Constants.googleApiKey)
        GMSPlacesClient.provideAPIKey("AIzaSyDWI7jF12WdwKtAQW_TrCtI_2P_9EfFySI")
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UserConstant.shared.fetchRequiredConstants()
    }
}

