//
//  ParcelInfoTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol ApplyPromoProtocol {
    func applyPromo(model: CouponCodeModel, code: String)
    func didSelectCategory(category: Category)
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
    
    var parcelValues: [Category] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    var formFieldModel: FormFieldModel!
    var indexPath: IndexPath!
    var delegate: ReloadCellProtocol?
    var promoCodeDelegate: ApplyPromoProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.txtParcelType.isEnabled = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundView?.backgroundColor = self.backgroundColor
        
        self.collectionView.register(UINib(nibName: ParcelTypeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ParcelTypeCollectionViewCell.identifier)
        
        self.txtParcelType.delegate = self
        self.txtParcelValue.delegate = self
        self.txtPromoCode.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(with model: FormFieldModel) {
        self.formFieldModel = model
        
        for formField in model.formSubFields {
            switch formField.type {
            case .parcelType:
                self.lblParcelTypeTitle.text = formField.title
                self.txtParcelType.text = (formField.value as? Category)?.title
            case .parcelValue:
                self.lblParcelValueTitle.text = formField.title
                self.txtParcelValue.text = formField.value as? String
            case .promoCode:
                self.lblPromoCodeTitle.text = formField.title
                self.txtPromoCode.text = (formField.value as? CouponCodeModel)?.couponCode
            default:
                assertionFailure("Wrong field appears here")
            }
        }
    }
    
    @IBAction func btnApplyPromoCode(_ sender: UIButton) {
        for formField in self.formFieldModel.formSubFields {
            switch formField.type {
            case .promoCode:
                self.promoCodeDelegate?.applyPromo(model: formField.value as! CouponCodeModel, code: self.txtPromoCode.text!)
            default:
                print("Wrong field")
//                assertionFailure("Wrong field appears here")
            }
        }
        
    }
}

extension ParcelInfoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parcelValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ParcelTypeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ParcelTypeCollectionViewCell.identifier, for: indexPath) as? ParcelTypeCollectionViewCell else {
            assertionFailure("Couldn't dequeue ::>> \(ParcelTypeCollectionViewCell.identifier)")
            return UICollectionViewCell()
        }
        
        cell.lblParcelType.text = self.parcelValues[indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.promoCodeDelegate?.didSelectCategory(category: self.parcelValues[indexPath.row])
    }
}

extension ParcelInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.parcelValues[indexPath.row].title.size(withAttributes: [NSAttributedString.Key.font : FontUtility.roboto(style: .Medium, size: 14)]).width + 40
        return CGSize(width: width, height: 34)
    }
}

extension ParcelInfoTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtParcelValue {
            if let formField = (self.formFieldModel.formSubFields.filter { $0.type == .parcelValue }).first {
                formField.value = textField.text!
            }
        } else if textField == self.txtPromoCode {
            if let formField = (self.formFieldModel.formSubFields.filter { $0.type == .promoCode }).first {
                formField.value = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
