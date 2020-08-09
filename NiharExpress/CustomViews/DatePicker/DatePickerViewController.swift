//
//  DatePickerViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var previousPickedDate: Date?
    var pickedDate: Date?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var datePicked: ((Date) -> Void)?
    var dismissed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
    }
    
    func configureUI() {
        if let date = self.previousPickedDate {
            self.datePicker.minimumDate = date
            self.datePicker.datePickerMode = .time
        } else {
            self.datePicker.minimumDate = Date()
        }
        self.datePicker.addTarget(self, action: #selector(self.datePicked(_:)), for: .valueChanged)
    }

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismissed?()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        self.datePicked?(self.pickedDate ?? Date())
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func datePicked(_ datePicker: UIDatePicker) {
        self.pickedDate = datePicker.date
    }
}
