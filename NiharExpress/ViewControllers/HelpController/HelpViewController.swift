//
//  HelpViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showAndUpdateNavigationBar(with: "Help", withShadow: true, isHavingBackButton: false)
    }
    
    func configureUI() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
    }
}

extension HelpViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as? ProfileTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(ProfileTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.updateData(with: AppIcons.questionMark.rawValue, title: "FAQ's", subTitle: "", trailing: "")
        } else if indexPath.row == 1 {
            cell.updateData(with: AppIcons.questionMark.rawValue, title: "Support", subTitle: "", trailing: "")
        }
        
        cell.lblIcon.font = FontUtility.niharExpress(size: 18)
        cell.lblTitle.textColor = UIColor.darkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.loadWebPage(url: "http://niharexpress.com/site/getFaq?type=C", title: "FAQ's")
        } else if indexPath.row == 1 {
            self.loadWebPage(url: "https://niharexpress.com/site/getContent?type=C&section=Support", title: "Support")
        }
    }
    
    func loadWebPage(url: String, title: String) {
        let webController = WebViewViewController()
        webController.titleString = title
        webController.urlString = url
        
        self.navigationController?.pushViewController(webController, animated: true)
    }
}
