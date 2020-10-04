//
//  ReferNEarnViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 04/10/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class ReferNEarnViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [(title: String, btnTitle: String)] = [
        (title: "Refer a friend and get free delivery on Nihar Express using your promocode. You can use referral code within 30 days of referral.", btnTitle: "REFER NOW"),
        (title: "Refer a friend, family or anyone, using the promo code below. You and your buddy will get free delivery upto Rs. 30 for each reference.", btnTitle: "REFERENCE DISCOUNT")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showAndUpdateNavigationBar(with: "Refer n Earn", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
        
        let notificationBarButton = self.addNotificationBarButton(actionController: self, notificationAction: #selector(self.notificationAction(_:)))
        Util.setNotificationCount(btn: notificationBarButton)
    }
    
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: ReferEarnTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ReferEarnTableViewCell.identifier)
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notificationAction(_ sender: UIBarButtonItem) {
        let notificationController = NotificationViewController()
        self.navigationController?.pushViewController(notificationController, animated: true)
    }
}

extension ReferNEarnViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReferEarnTableViewCell.identifier) as? ReferEarnTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(ReferEarnTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        cell.indexPath = indexPath
        cell.updateData(with: self.data[indexPath.row].title, btnTitle: self.data[indexPath.row].btnTitle)
        
        cell.btnAction = { (indexPath) in
            
        }
        
        return cell
    }
}
