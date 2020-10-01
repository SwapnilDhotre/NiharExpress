//
//  DateTimePickerTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol DatePickerProtocol {
    func datePickerAction(model: FormSubFieldModel)
}

class DateTimePickerTableViewCell: UITableViewCell {
    static var identifier = "DateTimePickerTableViewCell"
    
    var model: FormSubFieldModel!
    
    @IBOutlet weak var lblOneDifference: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblDateHolder: UILabel!
    @IBOutlet weak var lblTimeHolder: UILabel!
    
    @IBOutlet weak var lblCalendarIcon: UILabel!
    @IBOutlet weak var lblTimerIcon: UILabel!
    
    var delegate: DatePickerProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        self.lblCalendarIcon.font = FontUtility.niharExpress(size: 20)
        self.lblCalendarIcon.text = AppIcons.calendar.rawValue
        self.lblCalendarIcon.textColor = ColorConstant.appBlackLabel.color
        
        self.lblTimerIcon.font = FontUtility.niharExpress(size: 20)
        self.lblTimerIcon.text = AppIcons.clock.rawValue
        self.lblTimerIcon.textColor = ColorConstant.appBlackLabel.color
        
        self.lblDateHolder.textAlignment = .center
        self.lblTimeHolder.textAlignment = .center
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model = model
        
        let firstDate = model.value as? Date
        
        if let date = firstDate {
            self.lblDateHolder.text = date.toString(withFormat: "dd.MM")
        }
        
        if let fDate = firstDate {
            self.lblTimeHolder.text = fDate.toString(withFormat: "HH:mm")
            
            self.lblOneDifference.text = "Your Order Pickup Between \(fDate.toString(withFormat: "hh:mm a")) - \(fDate.adding(minutes: 60).toString(withFormat: "hh:mm a"))"
        }
    }
    
    @IBAction func btnDatePickerAction(_ sender: UIButton) {
        self.delegate?.datePickerAction(model: self.model)
    }
}
