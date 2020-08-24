//
//  Constants.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/13/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

class Constants {
    static let googleApiKey = "AIzaSyCaAqBQK94LMz7gPiEpdqIBAHDoQ0npm_k"
    
    struct API {
        static let method = "method"
        static let key = "key"
        
        // MARK: -  Login with OTP
        static let mod = "mod"
        
        // MARK: - Registration
        static let name = "name"
        static let emaildId = "email_id"
        static let mobileNo = "mobile_no"
        static let otp = "otp"
        
        /* Create Order */
        static let categoryId = "category_id"
        static let weight = "weight"
        static let pickUpPoint = "pickup_point"
        static let deliveryPoint = "delivery_point"
        
        static let optimizeRoute = "is_optimize"
        
        static let pickUpAddress = "pickup_address"
        static let pickUpName = "pickup_name"
        static let pickUpMobile = "pickup_mobile_no"
        static let pickUpDate = "pickup_date"
        static let pickUpTime = "pickup_time"
        static let pickUpComment = "pickup_comment"
        static let pickUpStoreName = "pickup_store_name"
        static let pickUpStoreContactNo = "pickup_store_contact_no"
        static let pickUpOrderType = "pickup_order_type"
        static let pickUptransactionType = "pickup_transaction_type"
        
        
        static let deliveryAddress = "delivery_address[]"
        static let deliveryMobile = "delivery_mobile_no[]"
        static let deliveryName = "delivery_name[]"
        static let deliveryDate = "delivery_date[]"
        static let deliveryTime = "delivery_time[]"
        static let deliveryComment = "delivery_comment[]"
        static let deliveryStoreName = "delivery_store_name[]"
        static let deliveryStoreContactNo = "delivery_store_contact_no[]"
        static let deliveryOrderType = "delivery_order_type[]"
        static let deliveryTransactionType = "delivery_transaction_type[]"
        
        static let orderType = "order_type"
        static let price = "price"
        static let customerId = "customer_id"
        static let cityId = "city_id"
        static let paymentMethod  = "payment_method"
        static let paymentAddress  = "pyment_address"
        static let insurancePrice = "insurance_price"
        static let parcelPrice = "parcel_price"
        static let senderSMSNotification = "sender_sms_notification"
        static let receiverNotification = "receiver_sms_notification"
        static let orderId = "order_id"
        static let couponId = "coupon_id"
        static let discount = "discount"
        static let distance = "distance"
        /* Create Order */
        
        /* Orders History */
        static let listOrder = "listOrder"
        static let orderStatus = "order_status"
        /* Orders History */
        
        static let reason = "reason"
        static let overAllRating = "overall_rating"
        static let driverRating = "driver_rating"
 
    }
    
    enum MethodType: String {
        case getOTP = "getOtp"
        case login = "login"
        case registration = "registration"
        case listCategory = "listCategory"
        case getPrice = "getPrice"
        case placeOrder = "placeOrder"
        
        case listOrder = "listOrder"
        
        case listReason = "listReason"
        case cancelOrder = "cancelOrder"
        case orderRating = "orderRating"
        
        case listNotification = "listNotification"
        case listCity = "listCity"
        case getLocation = "getLocation"
    }
    
    struct headers {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let accept = "Accept"
        static let contentType = "Content-Type"
    }
    
    struct Response {
        static let response = "response"
        static let responseCode = "resp_code"
        static let code = "code"
        static let data = "data"
        static let status = "status"
        static let message = "msg"
        static let error = "error"
        static let errors = "errors"
        static let token = "token"
        static let otp = "otp"
        static let login = "login"
        
        static let customerId = "customer_id"
    }
}
