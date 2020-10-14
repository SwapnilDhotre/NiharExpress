//
//  TransactionTypeTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol TransactionTypeDelegate {
    func transactionTypeAction(sender: UIButton, model: FormSubFieldModel)
}

class TransactionTypeTableViewCell: UITableViewCell {
    static var identifier = "TransactionTypeTableViewCell"
    
    @IBOutlet weak var btnTransaction: UIButton!
    @IBOutlet weak var lblRupeeTitle: UILabel!
    @IBOutlet weak var txtTransactionAmountField: UITextField!
    @IBOutlet weak var amountLineView: UIView!
    
    @IBOutlet weak var lblDownCaret: UILabel!
    var model: FormSubFieldModel!
    var delegate: TransactionTypeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
        self.btnTransaction.setTitle("No Transaction", for: .normal)
        
        self.lblDownCaret.text = FontAwesome.angleDown.rawValue
        self.lblDownCaret.textColor = UIColor.gray
        self.lblDownCaret.font = UIFont.fontAwesome(ofSize: 14, style: .regular)
        
        self.txtTransactionAmountField.delegate = self
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model  = model
        
        self.lblRupeeTitle.isHidden = true
        self.amountLineView.isHidden = true
        self.txtTransactionAmountField.isHidden = true
        
        if let valueType = model.value as? (transactionType: String, transactionAmount: String) {
            if valueType.transactionType != "No Transaction" {
                self.lblRupeeTitle.isHidden = false
                self.amountLineView.isHidden = false
                self.txtTransactionAmountField.isHidden = false
                
                self.btnTransaction.setTitle(valueType.transactionType, for: .normal)
                self.txtTransactionAmountField.text = valueType.transactionAmount
            } else {
                self.btnTransaction.setTitle(valueType.transactionType, for: .normal)
            }
        }
    }
    
    @IBAction func btnTransactionAction(_ sender: UIButton) {
        self.delegate?.transactionTypeAction(sender: sender, model: self.model)
    }
}

extension TransactionTypeTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.model.value = (self.btnTransaction.titleLabel!.text, textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
