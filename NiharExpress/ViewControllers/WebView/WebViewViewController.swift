//
//  WebViewViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/9/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKUIDelegate {
    
    var titleString: String!
    var urlString: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showAndUpdateNavigationBar(with: self.titleString, withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnPressed(_:)))
    }
    
    func configureUI() {
        let webConfiguration = WKWebViewConfiguration()
        let webkitView = WKWebView(frame: .zero, configuration: webConfiguration)
        webkitView.uiDelegate = self
        
        if let url = URL(string: self.urlString) {
            let request = URLRequest(url: url)
            webkitView.load(request)
        }
        
        self.view = webkitView
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


