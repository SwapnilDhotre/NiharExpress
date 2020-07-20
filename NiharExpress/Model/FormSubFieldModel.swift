//
//  FormSubFieldModel.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

enum FormSubFieldType {
    case address
    case phoneNo
    case whenToPickup
    case whenToDelivery
    case comment
    case contactPerson
    case contactNo
    case transaction
    
    case parcelType
    case parcelValue
    case promoCode
    
    case notifyMeBySMS
    case notifyRecipientsBySMS
}

class FormSubFieldModel {
    var title: String
    var type: FormSubFieldType
    var value: Any
    
    init(title: String, type: FormSubFieldType, value: Any) {
        self.title = title
        self.type = type
        self.value = value
    }
}
