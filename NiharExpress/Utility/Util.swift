//
//  Util.swift
//  Nihar
//
//  Created by Swapnil Dhotre on 24/05/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class Util {
    
    static func setIntialController(window: UIWindow) {
        
        window.rootViewController = UINavigationController(rootViewController: SplashScreenViewController())
        window.makeKeyAndVisible()
    }
    
    static func isBackPressed(string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(char, "\u{8}"))
        if isBackSpace == -8 {
            return true
        } else {
            return false
        }
    }
    
    static func setNotificationCount(btn: UIButton) {
        self.fetchAndUpdateNotifications { (notifications, apiStatus) in
            DispatchQueue.main.async {
                btn.badge(with: notifications.count, badgeBackgroundColor: ColorConstant.orderDetailsActiveBanner.color)
            }
        }
    }
    
    static func fetchAndUpdateNotifications(completion: @escaping (([NotificationModel], APIStatus?) -> Void)) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.listNotification.rawValue,
            Constants.API.key: "41979bf5da2d2bfbae66fda5ac59ed132216b87b",
            Constants.API.customerId: UserConstant.shared.userModel.id,
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let notifications: [NotificationModel] = try! JSONDecoder().decode([NotificationModel].self, from: jsonData)
                    completion(notifications, nil)
                } else {
                    completion([], apiStatus)
                }
            }
        }
    }
}
