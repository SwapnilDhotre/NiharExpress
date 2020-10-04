//
//  ReferEarnTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 04/10/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class ReferEarnTableViewCell: UITableViewCell {
    
    static var identifier: String = "ReferEarnTableViewCell"

    var indexPath: IndexPath!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnReferNow: DesignableButton!
    @IBOutlet weak var btnWith: NSLayoutConstraint!
    
    var btnAction: ((IndexPath) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateData(with title: String, btnTitle: String) {
        self.lblTitle.text = title
        self.btnReferNow.setTitle(btnTitle, for: .normal)
        
        if indexPath.row == 0 {
            self.btnWith.constant = 120
        } else{
            self.btnWith.constant = 170
        }
        
        self.btnReferNow.addTarget(self, action: #selector(self.referBtnAction), for: .touchUpInside)
    }
    
    @objc func referBtnAction(sender: UIButton) {
        self.btnAction?(self.indexPath)
    }
    
}
