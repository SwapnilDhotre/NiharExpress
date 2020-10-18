//
//  InfoWindow.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 18/10/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class InfoWindow: UIView {
    
    let kCONTENT_XIB_NAME = "InfoWindow"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet var contentView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        contentView.backgroundColor = .clear
    }
}
