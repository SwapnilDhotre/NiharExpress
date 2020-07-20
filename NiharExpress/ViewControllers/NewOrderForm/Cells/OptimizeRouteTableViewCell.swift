//
//  OptimizeRouteTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class OptimizeRouteTableViewCell: UITableViewCell {
    static var identifier = "OptimizeRouteTableViewCell"

    @IBOutlet weak var lblQuestionMarkIcon: UILabel!
    @IBOutlet weak var lblOptimizeTitle: UILabel!
    @IBOutlet weak var btnOptimizeRoute: UIButton!
    
    var formFieldModel: FormFieldModel!
    var indexPath: IndexPath!
    var delegate: ReloadCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI() {
        self.lblQuestionMarkIcon.text = AppIcons.outlineHelp.rawValue
        self.lblQuestionMarkIcon.textColor = ColorConstant.appBlackLabel.color
        self.lblQuestionMarkIcon.font = FontUtility.niharExpress(size: 22)
        
        self.btnOptimizeRoute.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .regular)
        self.btnOptimizeRoute.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
    }
    
    func updateData(with model: FormFieldModel) {
        self.formFieldModel = model
        
        self.lblOptimizeTitle.text = formFieldModel.title
        let icon = formFieldModel.value as! Bool ? FontAwesome.checkSquare.rawValue : FontAwesome.square.rawValue
        self.btnOptimizeRoute.setTitle(icon, for: .normal)
    }
    
    @IBAction func btnOptimizeRouteAction(_ sender: UIButton) {
        if formFieldModel.value as! Bool {
            formFieldModel.value = false
        } else {
            formFieldModel.value = true
        }
        self.delegate?.reloadCell(for: indexPath)
    }
}
