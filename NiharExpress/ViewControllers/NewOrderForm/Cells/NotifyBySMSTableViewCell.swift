//
//  NotifyBySMSTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class NotifyBySMSTableViewCell: UITableViewCell {
    static var identifier = "NotifyBySMSTableViewCell"
    
    @IBOutlet weak var lblNotifyMe: UILabel!
    @IBOutlet weak var lblNotifyRecipients: UILabel!
    
    @IBOutlet weak var switchNotifyMe: UISwitch!
    @IBOutlet weak var switchNotifyRecipients: UISwitch!
    
    var formFieldModel: FormFieldModel!
    var indexPath: IndexPath!
    var delegate: ReloadCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateData(with model: FormFieldModel) {
        self.formFieldModel = model
        
        for formSubField in model.formSubFields {
            switch formSubField.type {
            case .notifyMeBySMS:
                self.lblNotifyMe.text = formSubField.title
                self.switchNotifyMe.setOn(formSubField.value as! Bool, animated: true)
            case .notifyRecipientsBySMS:
                self.lblNotifyRecipients.text = formSubField.title
                self.switchNotifyRecipients.setOn(formSubField.value as! Bool, animated: true)
            default:
                assertionFailure("Wrong field appears here")
            }
        }
    }
    
    @IBAction func notifyAction(_ sender: UISwitch) {
        if sender == switchNotifyMe {
            if let formField = (formFieldModel.formSubFields.filter { $0.type == .notifyMeBySMS }).first {
                formField.value = sender.isOn
            }
        } else {
            if let formField = (formFieldModel.formSubFields.filter { $0.type == .notifyRecipientsBySMS }).first {
                formField.value = sender.isOn
            }
        }
    }
}
