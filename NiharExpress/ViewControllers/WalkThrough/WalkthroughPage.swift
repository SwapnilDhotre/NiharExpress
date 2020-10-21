//
//  WalkthroughView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 10/20/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class WalkthroughPage: UIView {
    let kCONTENT_XIB_NAME = "WalkthroughPage"
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
        
    }
    
    func updateView(with image: String, title: String) {
        self.imageView.image = UIImage(named: image)
        self.lblTitle.text = title
    }
}
