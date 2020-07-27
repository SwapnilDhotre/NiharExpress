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
        static let method = "method"
        static let key = "key"
        
        // MARK: -  Login with OTP
        static let mod = "mod"
        
        // MARK: - Registration
        static let name = "name"
        static let emaildId = "email_id"
        static let mobileNo = "mobile_no"
        static let otp = "otp"
    }
    
    enum MethodType: String {
        case getOTP = "getOtp"
        case registration = "registration"
        
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
        static let data = "data"
        static let status = "status"
        static let message = "msg"
        static let error = "error"
        static let errors = "errors"
        static let token = "token"
        static let otp = "otp"
        static let login = "login"
    }
}
