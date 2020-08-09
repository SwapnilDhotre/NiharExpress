//
//  UserConstant.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class UserConstant {
    static var shared = UserConstant()
    
    var token: String = "" {
        didSet {
            UserDefaultManager.shared.set(value: token, forKey: .token)
        }
    }
    
    var city: City! {
        didSet {
            if let data = try? JSONEncoder().encode(self.city), let encodedString = String(data: data, encoding: .utf8) {
                UserDefaultManager.shared.set(value: encodedString, forKey: .city)
            }
        }
    }
    
    var userModel: User! {
        didSet {
            if let data = try? JSONEncoder().encode(self.userModel), let encodedString = String(data: data, encoding: .utf8) {
                UserDefaultManager.shared.set(value: encodedString, forKey: .userModel)
            }
        }
    }
    
//    var appInfo: AppInfo! {
//        didSet {
//            if let data = try? JSONEncoder().encode(self.appInfo), let encodedString = String(data: data, encoding: .utf8) {
//                UserDefaultManager.shared.set(value: encodedString, forKey: .appInfo)
//            }
//        }
//    }
    
    private init() {}
    
    func fetchRequiredConstants() {
        self.token = (UserDefaultManager.shared.valueFor(key: .token, type: .string) as? String) ?? ""
        if let stringModel = UserDefaultManager.shared.valueFor(key: .userModel, type: .string) as? String, let data = stringModel.data(using: .utf8) {
            self.userModel = try? JSONDecoder().decode(User.self, from: data)
        }

//        if let stringModel = UserDefaultManager.shared.valueFor(key: .appInfo, type: .string) as? String, let data = stringModel.data(using: .utf8) {
//            self.appInfo = try? JSONDecoder().decode(AppInfo.self, from: data)
//        }
    }
    
    func reset() {
        UserConstant.shared = UserConstant()
    }
}
