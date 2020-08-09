//
//  OrderDetailsViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    var order: Order!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerViewTitle: UILabel!
    @IBOutlet weak var bannerView: UIView!
    var addressViews: [OrderAddress] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.order.orderStatus.lowercased() == "delivered" {
            self.bannerViewTitle.text = "\(self.order.orderStatus) \(self.order.orderDate.toString(withFormat: "MMM dd, yyyy"))"
            self.bannerView.backgroundColor = UIColor.darkGray
        } else {
            self.bannerViewTitle.text = self.order.orderStatus
            self.bannerView.backgroundColor = UIColor(hex: "#00bfb0")
        }
        
        self.showAndUpdateNavigationBar(with: "Order \(order.orderNo)", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnPressed(_:)))
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureUI() {
        self.addressViews.append(self.order.pickUp)
        self.addressViews.append(contentsOf: self.order.delivery)
        
        self.addressViews.first?.isFirstCell = true
        self.addressViews.last?.isLastCell = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: OrderDetailsLocationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderDetailsLocationTableViewCell.identifier)
        self.tableView.register(UINib(nibName: InformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InformationTableViewCell.identifier)
        self.tableView.register(UINib(nibName: OrderDeliveredTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderDeliveredTableViewCell.identifier)
        self.tableView.register(UINib(nibName: InProgressTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InProgressTableViewCell.identifier)
    }
    
    // MARK: - Action Methods
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension OrderDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressViews.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if self.order.orderStatus.lowercased() == "delivered" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDeliveredTableViewCell.identifier) as? OrderDeliveredTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(OrderDeliveredTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.updateData(with: self.order)
                cell.delegate = self
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressTableViewCell.identifier) as? InProgressTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(InProgressTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.updateData(with: self.order)
                cell.delegate = self
                
                return cell
            }
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier) as? InformationTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(InformationTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.updateData(wtih: self.order)
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailsLocationTableViewCell.identifier) as? OrderDetailsLocationTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(OrderDetailsLocationTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            let address = self.addressViews[indexPath.row - 2]
            cell.updateData(with: address, isDelivered: self.order.orderStatus.lowercased() == "delivered")
            cell.selectionStyle = .none
            
            cell.lblCounter.text = "\(indexPath.row - 1)"
            
            cell.isFirst = address.isFirstCell
            cell.isLast = address.isLastCell
            
            return cell
        }
    }
}

extension OrderDetailsViewController: OrderDeliveredProtocol {
    func cloneAction() {
        
    }
    
    func starAction() {
        
    }
}

extension OrderDetailsViewController: InProgressOrderProtocol {
    func modifyOrder() {
    
    }
    
    func cloneOrder() {
        
    }
    
    func cancelOrder() {
        let cancelOrderController = CancellationOrderViewController()
        cancelOrderController.modalPresentationStyle = .overCurrentContext
        
        self.present(cancelOrderController, animated: false, completion: nil)
    }
    

}
