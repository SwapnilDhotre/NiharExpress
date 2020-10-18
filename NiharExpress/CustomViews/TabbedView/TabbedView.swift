//
//  TabbedView.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/4/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol TabbedViewDataSource {
    func tabTitles() -> [String]
    func reloadContainer(for tab: TabModel, index: Int) -> UIView
}

class TabbedView: UIView {
    
    let kCONTENT_XIB_NAME = "TabbedView"
    @IBOutlet var contentView: UIView!
    
    var tabs: [TabModel] = []
    
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    
    var tabbedDatasource: TabbedViewDataSource?
    var tabCommonWidth: CGFloat = 0
    var lineView: UIView!
    
    var cellBackgroundColor: UIColor?
    
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
        
        self.tabsCollectionView.dataSource = self
        self.tabsCollectionView.delegate = self
        self.tabsCollectionView.backgroundView?.backgroundColor = self.backgroundColor
        
        self.tabsCollectionView.register(UINib(nibName: SingleLineCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SingleLineCollectionViewCell.identifier)
        
        self.reloadTabs()
    }
    
    func reloadTabs() {
        self.tabsCollectionView.reloadData()
        if let dataSource = self.tabbedDatasource {
            self.tabs = dataSource.tabTitles().map({
                TabModel(id: 123, title: $0, isSelected: false)
            })
            
            self.tabs.first?.isSelected = true
            
            self.calculateTabWidth()
            self.addLineView()
        }
    }
    
    func addLineView() {
        if self.lineView == nil {
            // LineView Create for tabs
            self.lineView = UIView(frame: CGRect(x: 0, y: self.tabsCollectionView.frame.height - 1, width: self.tabCommonWidth == 0 ? self.tabs[0].title.titleWidth() : self.tabCommonWidth, height: 1))
            self.lineView.backgroundColor = ColorConstant.themePrimary.color
            self.lineView.tag = 402
            
            if !(self.tabsCollectionView.subviews.contains { subView in
                subView.tag == 402
            }) {
                self.tabsCollectionView.addSubview(self.lineView)
            }
        }
    }
    
    func calculateTabWidth() {
        var totalWidth: CGFloat = 0
        self.tabs.forEach({
            totalWidth += $0.title.titleWidth()
        });
        if (self.contentView.frame.width > totalWidth) {
            self.tabCommonWidth = self.contentView.frame.width / CGFloat(self.tabs.count)
        } else {
            self.tabCommonWidth = 0
        }
    }
    
    func setSelectionState(index: Int, cell: SingleLineCollectionViewCell) {
        let tab = self.tabs[index]
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
            self.lineView.frame = CGRect(x: self.lineView.frame.origin.x, y: self.lineView.frame.origin.y, width: self.tabCommonWidth == 0 ? tab.title.titleWidth() : self.tabCommonWidth, height: 1)
            self.lineView.center.x = cell.center.x
        })
        
        if let view = self.tabbedDatasource?.reloadContainer(for: tab, index: index) {
            self.containerView.subviews.forEach({
                $0.removeFromSuperview()
            })
            self.containerView.addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        }
    }
}

extension TabbedView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.calculateTabWidth()
        
        return self.tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SingleLineCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleLineCollectionViewCell.identifier, for: indexPath) as? SingleLineCollectionViewCell else {
            assertionFailure("Couldn't dequeue ::>> \(SingleLineCollectionViewCell.identifier)")
            return UICollectionViewCell()
        }
        
        if (self.tabs[indexPath.row].isSelected) {
            self.setSelectionState(index: indexPath.row, cell: cell)
            cell.setTitleFont(font: FontUtility.roboto(style: .Bold, size: 12), color: ColorConstant.themePrimary.color)
        } else {
            cell.setTitleFont(font:FontUtility.roboto(style: .Bold, size: 12), color: ColorConstant.appBlackLabel.color)
        }
        
        cell.updateView(with: self.tabs[indexPath.row].title)
        cell.backgroundColor = cellBackgroundColor ?? .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setSelectedIndex(tabIndex: indexPath.row)
    }
    
    func setSelectedIndex(tabIndex: Int) {
        if tabIndex > self.tabs.count - 1 || tabIndex < 0 {
            print("Invalid tab index to select")
            return
        }
        
        for tab in self.tabs {
            tab.isSelected = false
        }
        let indexPath = IndexPath(row: tabIndex, section: 0)
        self.tabs[indexPath.row].isSelected = true
        self.tabsCollectionView.reloadData()
        self.tabsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension TabbedView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.tabCommonWidth == 0 ? self.tabs[indexPath.row].title.titleWidth() : self.tabCommonWidth, height: 40)
    }
}
