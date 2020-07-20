//
//  ParcelInfoTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol ApplyPromoProtocol {
    func applyPromo(code: String)
}

class ParcelInfoTableViewCell: UITableViewCell {
    static var identifier = "ParcelInfoTableViewCell"

    @IBOutlet weak var lblParcelTypeTitle: UILabel!
    @IBOutlet weak var txtParcelType: UITextField!
    @IBOutlet weak var parcelTypeLine: UIView!
   
    @IBOutlet weak var lblParcelValueTitle: UILabel!
    @IBOutlet weak var txtParcelValue: UITextField!
    @IBOutlet weak var parcelValueLIne: UIView!
    
    @IBOutlet weak var lblPromoCodeTitle: UILabel!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var promocodeLine: UIView!
    
    @IBOutlet weak var btnApply: UIButton!
    
    var formFieldModel: FormFieldModel!
    var indexPath: IndexPath!
    var delegate: ReloadCellProtocol?
    var promoCodeDelegate: ApplyPromoProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(with model: FormFieldModel) {
        self.formFieldModel = model
        
        for formField in model.formSubFields {
            switch formField.type {
            case .parcelType:
                self.lblParcelTypeTitle.text = formField.title
                self.txtParcelType.text = formField.value as? String
            case .parcelValue:
                self.lblParcelValueTitle.text = formField.title
                self.txtParcelValue.text = formField.value as? String
            case .promoCode:
                self.lblPromoCodeTitle.text = formField.title
                self.txtPromoCode.text = formField.value as? String
            default:
                assertionFailure("Wrong field appears here")
            }
        }
    }
}
