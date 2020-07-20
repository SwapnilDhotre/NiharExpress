//
//  Constants.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/13/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class Constants {
    struct API {
        static let userPhone = "userPhone"
        static let password = "password"
        static let otp = "otp"
        static let deviceId = "deviceId"
        static let fcmToken = "fcmToken"
        static let token = "token"
        
        static let addressId = "addressId"
        static let fullAddress = "fullAddress"
        static let houseNo = "houseNo"
        static let landmark = "landmark"
        static let pin = "pin"
        static let addType = "addType"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let selectStatus = "selectStatus"
        static let receiverName = "receiverName"
        static let receiverPhone = "receiverPhone"
        
        static let firstName = "userFirstName"
        static let lastName = "userLastName"
        static let userEmail = "userEmail"
        static let userImage = "userImage"
        static let oldPassword = "oldPassword"
        static let familyMembers = "familyMembers"
        static let dietType = "dietType"
        
        static let keyword = "keyword"
        static let productId = "productId"
        
        static let catId = "cat_id"
        
        static let cartId = "cartId"
        
        static let varientId = "varientId"
        static let categoryId = "categoryId"
        static let quantity = "quantity"
        static let noOfItems = "user_quantity"
        
        static let transactionId = "transactionId"
        static let cancellationReason = "reason"
        static let couponCode = "coupon_code"
        
        static let selectedDate = "selected_date"
    }
    
    struct headers {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    struct Response {
        static let data = "data"
        static let status = "status"
        static let message = "message"
        static let error = "error"
        static let errors = "errors"
        static let user_profile = "user_profile"
        static let user_address = "user_address"
        static let otp_value = "otp_value"
        static let token = "token"
        static let otp = "otp"
        static let login = "login"
        
        static let catId = "cat_id"
        static let title = "title"
        static let image = "image"
        
        static let product = "product"
        static let grandTotal = "grand_total"
        static let categoryproducts = "categoryProducts"
        
        static let orders = "orders"
        static let orderDetails = "order_details"
        static let address = "address"
        
        static let notification = "notification"
    }
}
