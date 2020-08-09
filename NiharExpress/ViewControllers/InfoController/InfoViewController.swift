//
//  InfoViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

struct InfoModel {
    var icon: AppIcons
    var title: String
    var subTitle: String
}

class InfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [InfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showAndUpdateNavigationBar(with: "Help", withShadow: true, isHavingBackButton: false)
    }
    
    func configureUI() {
        self.data = [
            InfoModel(icon: .cards, title: "Service Information", subTitle: "More about Nihar Express"),
            InfoModel(icon: .outlineInfo, title: "About", subTitle: "Version etc"),
            InfoModel(icon: .paperPad, title: "Terms and Conditions", subTitle: ""),
            InfoModel(icon: .businessBriefcase, title: "Business Packages", subTitle: "")
        ]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as? ProfileTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(ProfileTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        let infoModel = self.data[indexPath.row]
        cell.updateData(with: infoModel.icon.rawValue, title: infoModel.title, subTitle: infoModel.subTitle, trailing: "")
        
        cell.lblIcon.font = FontUtility.niharExpress(size: 22)
        cell.lblTitle.textColor = UIColor.darkGray
        
        if infoModel.icon == .outlineInfo {
            cell.lblIcon.textColor = UIColor(hex: "#FDA50F")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoModel = self.data[indexPath.row]
        self.loadWebPage(url: "", title: infoModel.title)
    }
    
    func loadWebPage(url: String, title: String) {
        let webController = WebViewViewController()
        webController.titleString = title
        webController.urlString = url
        
        self.navigationController?.pushViewController(webController, animated: true)
    }
}

