//
//  TransactonTypeSelectionViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 21/09/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol TransactionTypeSelectionDelegate {
    func transactionSelected(indexPath: IndexPath, type: String)
}

class TransactonTypeSelectionViewController: UIViewController {
    
    var delegate: TransactionTypeSelectionDelegate?
    
    var topConstraint: CGFloat = 0
    
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var indexPath: IndexPath!
    
    var transactionTypes = [
        "No Transaction",
        "Get Cash"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewLeadingConstraint.constant = 60
        self.viewTopConstraint.constant = topConstraint
        
        if transactionTypes.count > 5 {
            self.tableView.isScrollEnabled = true
            self.tableHeightConstraint.constant = CGFloat(5 * 40)
        } else {
            self.tableHeightConstraint.constant = CGFloat(transactionTypes.count * 40)
        }
    }
    
    @IBAction func btnBackdropAction(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.delegate?.transactionSelected(indexPath: self.indexPath, type: "")
        }
    }
}

extension TransactonTypeSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = self.transactionTypes[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.font = FontUtility.roboto(style: .Regular, size: 14)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false) {
            self.delegate?.transactionSelected(indexPath: self.indexPath, type: self.transactionTypes[indexPath.row])
        }
    }
}
