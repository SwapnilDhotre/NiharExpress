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
    @IBOutlet weak var txtTransactionAmountField: UITextField!

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
        
    }
    
    func updateData(with model: FormSubFieldModel) {
        self.model  = model
        
        self.btnTransaction.setTitle((model.value as? (transactionType: String, transactionAmount: String))?.transactionType, for: .normal)
        self.txtTransactionAmountField.text = (model.value as? (transactionType: String, transactionAmount: String))?.transactionAmount
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
