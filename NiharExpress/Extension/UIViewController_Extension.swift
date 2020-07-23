//
//  UIViewController_Extension.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var keyboardHeight: CGFloat = 0
    
    /// Add keyboard observer to viewController
    func addTextFieldObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.animateWithKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.animateWithKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Remove keyboard observer
    func removeTextFieldObserver() {
        UIViewController.keyboardHeight = 0
        self.view.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Animate keyboard either show or hide
    ///
    /// - Parameter notification: notification of keyboard to either show or hide
    @objc func animateWithKeyboard(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
            let moveUp = notification.name == UIResponder.keyboardWillShowNotification
            
            // If status is move up even if already keyboard is visible it means either height is increased or decreased. Calculated height that should increase with keyboard height.
            if moveUp {
                let height = -(UIViewController.keyboardHeight - keyboardHeight)
                print("Current height increase or decrease is:>>\(height)")
                self.animateView(keyboardHeight: height, duration: duration, curve: curve, up: moveUp)
            } else {
                self.animateView(keyboardHeight: keyboardHeight, duration: duration, curve: curve, up: moveUp)
            }
            
            UIViewController.keyboardHeight = moveUp ? keyboardHeight : 0
            print("Keyboard height:>>\(keyboardHeight)")
        }
    }
    
    /// Show animation to move view frame up/down.
    ///
    /// - Parameters:
    ///   - keyboardHeight: height of keyboard
    ///   - duration: duration to which keyboard should move
    ///   - curve: curve of animation that keyboard uses
    ///   - up: keyboard up/down
    func animateView(keyboardHeight: CGFloat, duration: Double, curve: Int, up: Bool) {
        let movement = (up ? -keyboardHeight : keyboardHeight)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        if let animationCurve = UIView.AnimationCurve(rawValue: curve) {
            UIView.setAnimationCurve(animationCurve)
        }
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func titleView(title: String) -> UIView {
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 40))
        titleView.text = "  \(title)"
//        titleView.font = FontUtility.nunitoSans(style: .Regular, size: 20)
//        titleView.textColor = ColorConstant.appBlackLabel.color
        
        return titleView
    }
    
    func getBackBarButton() -> UIButton {
        let iconButton = UIButton(frame:  CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 40)))
        iconButton.setBackButton()
        return iconButton
    }
    
    func showAndUpdateNavigationBar(with title: String, withShadow: Bool, isHavingBackButton: Bool, actionController: UIViewController? = nil, backAction: Selector? = nil) {
        
        if isHavingBackButton {
            let backBarButton = self.getBackBarButton()
            backBarButton.addTarget(actionController ?? self, action: backAction!, for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBarButton)
        }
        
        self.navigationItem.title = title
        
        self.showNavigationBar(withShadow: withShadow)
    }
    
    func showNavigationBar(withShadow shadow: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        if !shadow {
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showAlert(withMsg msg: String, title: String? = nil, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion?(action)
        }))
        
        self.present(alert, animated: true)
    }
    
    func showAlertAndCustomAction(withMsg msg: String, title: String? = nil, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        actions.forEach { (action) in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true)
        return alert
    }
}
