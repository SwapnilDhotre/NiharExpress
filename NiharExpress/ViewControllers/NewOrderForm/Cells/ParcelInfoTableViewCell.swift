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
    func didTogglePromoCode(model: CouponCodeModel)
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
    
    @IBOutlet weak var couponCodeToggle: UIButton!
    @IBOutlet weak var lblCouponCodeSuccess: UILabel!
    @IBOutlet weak var couponCodeBottomConstraint: NSLayoutConstraint!
    
    var formFieldModel: FormFieldModel!
    var indexPath: IndexPath!
    var delegate: ReloadCellProtocol?
    var promoCodeDelegate: ApplyPromoProtocol?
    
    var couponCode: CouponCodeModel?
    
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
        
        self.lblCouponCodeSuccess.isHidden = true
        self.couponCodeToggle.isHidden = true
        self.couponCodeBottomConstraint.priority = UILayoutPriority(850)
        
        self.couponCodeToggle.setTitle(FontAwesome.checkSquare.rawValue, for: .normal)
        self.couponCodeToggle.setTitleColor(ColorConstant.themePrimary.color, for: .normal)
        self.couponCodeToggle.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
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
                
                if let coupon = formField.value as? CouponCodeModel, coupon.couponId != "" {
                    self.lblCouponCodeSuccess.text = "Your \(coupon.couponCode) Successfully Added Discount \(coupon.discount)";
                    self.lblCouponCodeSuccess.isHidden = false
                    self.couponCodeToggle.isHidden = false
                    self.couponCodeBottomConstraint.priority = UILayoutPriority(950)
                    self.txtPromoCode.text = coupon.couponCode
                } else {
                    self.txtPromoCode.text = ""
                }
                
                self.contentView.setNeedsUpdateConstraints()
                
            default:
                assertionFailure("Wrong field appears here")
            }
        }
    }
    
    @IBAction func btnApplyPromoCode(_ sender: UIButton) {
        for formField in self.formFieldModel.formSubFields {
            switch formField.type {
            case .promoCode:
                if let couponCodeModel = formField.value as? CouponCodeModel {
                    self.promoCodeDelegate?.applyPromo(model: couponCodeModel, code: self.txtPromoCode.text!)
                }
            default:
                print("Wrong field")
                //                assertionFailure("Wrong field appears here")
            }
        }
    }
    
    @IBAction func btnCouponToggle(_ sender: UIButton) {
        for formField in self.formFieldModel.formSubFields {
            switch formField.type {
            case .promoCode:
                if let couponCodeModel = formField.value as? CouponCodeModel {
                    couponCodeModel.shouldApplyDiscount = !couponCodeModel.shouldApplyDiscount
                    
                    sender.setTitle(couponCodeModel.shouldApplyDiscount ? FontAwesome.checkSquare.rawValue : FontAwesome.square.rawValue, for: .normal)
                    
                    if couponCodeModel.shouldApplyDiscount {
                        sender.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
                    } else {
                        sender.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .regular)
                    }
                    self.promoCodeDelegate?.didTogglePromoCode(model: couponCodeModel)
                }
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
            if let formField = (self.formFieldModel.formSubFields.filter { $0.type == .promoCode }).first, let couponCodeModel = formField.value as? CouponCodeModel {
                couponCodeModel.couponCode = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
