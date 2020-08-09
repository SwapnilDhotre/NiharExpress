//
//  FormFieldModel.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation
import CoreLocation

enum FormFieldType {
    case weight
    case pickUpPoint
    case deliveryPoint
    case addDeliveryPoint
    case optimizeRoute
    case parcelInfo
    case notifyInfo
    case paymentInfo
}

class FormFieldModel {
    var title: String
    var type: FormFieldType
    var formSubFields: [FormSubFieldModel]
    var value: Any
    var paymentLocation: [PaymentWillOccurAt] = []
    
    var isSubFieldsVisible = true
    var isNestedSubFieldVisible = false
    
    init(title: String, type: FormFieldType, formSubFields: [FormSubFieldModel] = [], value: Any) {
        self.title = title
        self.type = type
        self.formSubFields = formSubFields
        self.value = value
    }
    
    static func getFormFields() -> [FormFieldModel] {
        return [
            FormFieldModel(title: "Weight", type: .weight, value: ""),
            FormFieldModel(title: "Pickup Point", type: .pickUpPoint, formSubFields: self.getPickupPointFields(), value: ""),
            FormFieldModel(title: "Delivery Point", type: .deliveryPoint, formSubFields: self.getDeliveryPointFields(), value: ""),
            FormFieldModel(title: "Add Delivery Point", type: .addDeliveryPoint, value: ""),
            FormFieldModel(title: "Optimize the route", type: .optimizeRoute, value: false),
            FormFieldModel(title: "", type: .parcelInfo, formSubFields: self.getParcelInfoFields(), value: ""),
            FormFieldModel(title: "", type: .notifyInfo, formSubFields: self.getNotifyFields(), value: ""),
            FormFieldModel(title: "", type: .paymentInfo, value: "")
        ]
    }
    
    static func getPickupPointFields() -> [FormSubFieldModel] {
        return [
            FormSubFieldModel(title: "Pickup Point", type: .header, value: true),
            FormSubFieldModel(title: "Address", type: .address, value: AddressModel(address: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))),
            FormSubFieldModel(title: "Name", type: .name, value: ""),
            FormSubFieldModel(title: "PhoneNumber", type: .phoneNo, value: ""),
            FormSubFieldModel(title: "When to arrive at this address", type: .whenToPickup, value: (fromDate: Date(), toDate: Date())),
            FormSubFieldModel(title: "Comments", type: .comment, value: ""),
            FormSubFieldModel(title: "For online store", type: .storeInfoHeader, value: false),
            FormSubFieldModel(title: "Contact Person", type: .contactPerson, value: ""),
            FormSubFieldModel(title: "Contact No", type: .contactNo, value: ""),
            FormSubFieldModel(title: "Transaction Type", type: .transaction, value: (transactionType: "", transactionAmount: "")),
        ]
    }
    
    static func getDeliveryPointFields() -> [FormSubFieldModel] {
        return [
            FormSubFieldModel(title: "Delivery Point", type: .header, value: true),
            FormSubFieldModel(title: "Address", type: .address, value: AddressModel(address: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))),
            FormSubFieldModel(title: "Name", type: .name, value: ""),
            FormSubFieldModel(title: "PhoneNumber", type: .phoneNo, value: ""),
            FormSubFieldModel(title: "Comments", type: .comment, value: ""),
            FormSubFieldModel(title: "For online store", type: .storeInfoHeader, value: false),
            FormSubFieldModel(title: "Contact Person", type: .contactPerson, value: ""),
            FormSubFieldModel(title: "Contact No", type: .contactNo, value: ""),
            FormSubFieldModel(title: "Transaction Type", type: .transaction, value: (transactionType: "", transactionAmount: "")),
        ]
    }
    
    static func getParcelInfoFields() -> [FormSubFieldModel] {
        return [
            FormSubFieldModel(title: "What are we sending?", type: .parcelType, value: Category(id: "", title: "", isSelected: false)),
            FormSubFieldModel(title: "Parcel Value", type: .parcelValue, value: ""),
            FormSubFieldModel(title: "Promocode", type: .promoCode, value: "")
        ]
    }
    
    static func getNotifyFields() -> [FormSubFieldModel] {
        return [
            FormSubFieldModel(title: "Notify me by SMS", type: .notifyMeBySMS, value: false),
            FormSubFieldModel(title: "Notify recipients by SMS", type: .notifyRecipientsBySMS, value: false)
        ]
    }
}
