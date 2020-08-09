//
//  UIButton_Extension.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/20/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

extension UIButton {
    func badge(with value: Int, badgeBackgroundColor: UIColor, foregroundColor: UIColor = UIColor.white) {
        
        if value == 0 {
            if let badgeView = self.subviews.first(where: { (view) -> Bool in
                view.tag == 1001
            }) {
                badgeView.removeFromSuperview()
            }
        } else {
            
            if let badgeView = self.subviews.first(where: { (view) -> Bool in
                view.tag == 1001
            }) {
                if let badgeLabel = (badgeView.subviews.first { (view) -> Bool in
                    view.tag == 1002
                }) as? UILabel {
                    badgeLabel.text =  value > 99 ? "+\(99)" : "\(value)"
                }
            } else {
                let view = DesignableView();
                view.tag = 1001
                view.backgroundColor = badgeBackgroundColor
                view.translatesAutoresizingMaskIntoConstraints = false
                view.cornerRadius = 8
                view.maskToBounds = true
                
                let badgeCount = UILabel()
                badgeCount.tag = 1002
                badgeCount.text = value > 99 ? "+\(99)" : "\(value)"
                badgeCount.textAlignment = .center
                badgeCount.textColor = foregroundColor
                badgeCount.font = FontUtility.roboto(style: .Bold, size: 10)
                badgeCount.translatesAutoresizingMaskIntoConstraints = false
                
                badgeCount.sizeToFit()
                
                view.addSubview(badgeCount)
                badgeCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
                badgeCount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
                badgeCount.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.5).isActive = true
                
                self.addSubview(view)
                
                view.heightAnchor.constraint(equalToConstant: 16).isActive = true
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
            }
        }
    }
    
    func setBackButton() {
        self.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .regular)
        self.setTitle(FontAwesome.angleLeft.rawValue, for: .normal)
        self.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
    }
    
    func setNotificationButton() {
        self.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        self.setTitle(FontAwesome.bell.rawValue, for: .normal)
        self.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
    }
    
    func setSearchButton() {
        self.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .regular)
        self.setTitle(FontAwesome.search.rawValue, for: .normal)
        self.setTitleColor(ColorConstant.appBlackLabel.color, for: .normal)
    }
    
    func showSpinner(with color: UIColor) {
        self.accessibilityLabel = self.titleLabel?.text // Keep title aside
        self.setTitle("", for: .normal)
        
        let spinner = UIActivityIndicatorView()
        spinner.color = color
        self.addSubview(spinner)
        
        spinner.startAnimating()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.heightAnchor.constraint(equalToConstant: 30).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    func hideSpinner() {
        self.setTitle(self.accessibilityLabel, for: .normal)
        for subView in self.subviews {
            if (subView is UIActivityIndicatorView) {
                subView.removeFromSuperview()
                break
            }
        }
    }
}
