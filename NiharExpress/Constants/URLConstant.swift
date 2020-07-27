//
//  URLConstant.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/13/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class URLConstant {
    
    static let baseURL = "http://jaspertechlabs.com/nihaar/appApi/api"
    static var imageBaseURL = ""
    
    static let domain = "webapi.saintfarms.com"
    
    //MARK: - PreLogin
    static var appInfo: String { return baseURL + "api/appInfo" }
    
    
    // MARK: - Login / Registration
    static var login: String { return baseURL + "api/login" }
    static var logout: String { return baseURL + "api/logout" }
    static var register: String { return baseURL + "api/register" }
    static var verifyPhone: String { return baseURL + "api/verifyPhone" }
    static var forgotPassword: String { return baseURL + "api/forgetPassword" }
    
    static var addAddress: String { return baseURL + "api/addAddress" }
    static var getAddress: String { return baseURL + "api/getAddress" }
    static var editAddress: String { return baseURL + "api/editAddress" }
    static var deleteAddress: String { return baseURL + "api/deleteAddress" }
    static var setDefaultAddress: String { return baseURL + "api/setDefault" }
    
    // MARK: - Update Profile
    static var updateProfile: String { return baseURL + "api/updateProfile" }
    static var updateProfileAddress: String { return baseURL + "api/profileAddress" }
    
    static var sendOTPPhoneNo: String { return baseURL + "api/checkPhone" }
    static var verifyOTPAndUpdatePhoneNo: String { return baseURL + "api/verifyUpdatePhone" }
    
    // MARK: - Dashboard
    static var categories: String { return baseURL + "api/getCat" }
    static var featured: String { return baseURL + "api/getFeaturedCat" }
    static var searchProduct: String { return baseURL + "api/search" }
    static var addToRecentSearch: String { return baseURL + "api/addRecentSearch" }
    static var recentSearchedProduct: String { return baseURL + "api/getRecentSearch" }
    
    //MARK: - Product View
    static var categoryProducts: String { return baseURL + "api/cat_product" }
    static var getDiscardedList: String { return baseURL + "api/getUserCategoryDiscartedList" }
    static var discardProduct: String { return baseURL + "api/discartFromCart" }
    static var addProductToCart: String { return baseURL + "api/addToCart" }
    static var clearRecentSearch: String { return baseURL + "api/deleteRecentSearch" }
    
    // MARK: - Cart
    static var addToCart: String { baseURL + "api/addToCart" }
    static var removeFromCart: String { baseURL + "api/removeFromCart" }
    static var getCart: String { baseURL + "api/getUserCart" }
    
    // MARK: - Orders
    static var ongoingOrders: String { baseURL + "api/ongoingOrders" }
    static var completedOrders: String { baseURL + "api/completedOrders" }
    static var orderById: String { baseURL + "api/getOrderByID" }
    static var cancelOrder: String { baseURL + "api/cancelOrder" }
    static var reOrder: String { baseURL + "api/reorder" }
    
    //MARK: - Checkout
    static var checkoutOrder: String { baseURL + "api/checkOut" }
    static var couponList: String { baseURL + "api/couponList" }
    static var applyCoupon: String { baseURL + "api/applyCoupon" }
    static var timeSlot: String { baseURL + "api/timeSlot" }
    static var paymentComplete: String { baseURL + "api/paymentComplete" }
    static var placeOrder: String { baseURL + "api/placeOrder" }
    
    //MARK: - Notifications
    static var notificationList: String { baseURL + "api/notificationlist" }
}
