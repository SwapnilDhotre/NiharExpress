//
//  EmptyOrderView.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/5/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol EmptyOrderViewActionsProtocol {
    func bookACourier()
    func trackMyOrder()
}

class EmptyOrderView: UIView {
    let kCONTENT_XIB_NAME = "EmptyOrderView"
    @IBOutlet var contentView: UIView!
    
    var tabs: [TabModel] = []
    
    var tabbedDatasource: TabbedViewDataSource?
    var tabCommonWidth: CGFloat = 0
    var lineView: UIView!
    
    var cellBackgroundColor: UIColor?
    
    var delegate: EmptyOrderViewActionsProtocol?
    
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
    
    @IBAction func btnBookCourierAction(_ sender: UIButton) {
        self.delegate?.bookACourier()
    }
    
    @IBAction func trackMyOrdersAction(_ sender: UIButton) {
        self.delegate?.trackMyOrder()
    }
    
}
