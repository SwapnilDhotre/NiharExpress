//
//  UserDefaultManager.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/20/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

enum UserDefaultTypes {
    case int
    case float
    case double
    case bool
    case string
    case any
}

enum UserDefaultKeys: String {
    case isLoggedIn
    case token
    case userModel
    case city
    case appInfo
    
    case isProductDemoViewed
    
    case fcmToken
}

class UserDefaultManager {
    static var shared = UserDefaultManager()
    private let defaults = UserDefaults.standard
    
    private init() { }
    
    func set(value: Any, forKey key: UserDefaultKeys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func valueFor(key: UserDefaultKeys, type: UserDefaultTypes) -> Any? {
        switch type {
        case .int: do {
            return defaults.integer(forKey: key.rawValue)
            }
        case .float: do {
            return defaults.float(forKey: key.rawValue)
            }
        case .double: do {
            return defaults.double(forKey: key.rawValue)
            }
        case .bool: do {
            return defaults.bool(forKey: key.rawValue)
            }
        case .any: do {
            return defaults.data(forKey: key.rawValue)
            }
        case .string: do {
            return defaults.string(forKey: key.rawValue)
            }
        }
    }
    
    func clear() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
