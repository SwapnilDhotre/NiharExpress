//
//  NewOrderFormTableViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

protocol FormDelegate {
    func formDismissal()
}

class NewOrderFormTableViewController: UITableViewController {
        
    var delegate: FormDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.closeBtnAction(_:)))
    }
    
    // MARK: - Action Methods
    @objc func closeBtnAction(_ sender: UIBarButtonItem) {
        self.delegate?.formDismissal()
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
