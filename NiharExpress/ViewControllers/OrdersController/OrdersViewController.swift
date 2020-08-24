//
//  OrdersViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var lblLoginButton: DesignableButton!
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var createOrderButton: DesignableButton!
    @IBOutlet weak var lblOrderWithNoOrganization: UILabel!
    
    @IBOutlet weak var tabbedView: TabbedView!
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var createOrderTopConstraint: NSLayoutConstraint!
    
    var orderData: [Order] = []
    
    var tableView: UITableView?
    var alertLoader: UIAlertController?
    
    var selectedTabIndex: Int = 0
    
    var cloneOrderWithFields: [FormFieldModel] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.cloneOrderWithFields.isEmpty {
            
            if UserConstant.shared.userModel == nil {
                self.showAndUpdateNavigationBar(with: "SAME DAY DELIVERY PARTNER", withShadow: true, isHavingBackButton: false, actionController: self, backAction: #selector(self.backBtnAction(_:)))
                self.tabbedView.isHidden = true
                self.resetAnimatedView()
            } else {
                self.showAndUpdateNavigationBar(with: "Orders", withShadow: false, isHavingBackButton: false, actionController: self, backAction: #selector(self.backBtnAction(_:)))
                
                self.tabbedView.isHidden = false
                
                self.addNotificationBarButton(actionController: self, notificationAction: #selector(self.notificationAction(_:)))
            }
            
            self.tabbedView.tabbedDatasource = self
            self.tabbedView.cellBackgroundColor = UIColor.white
            self.tabbedView.reloadTabs()
            
        } else {
            self.createNewOrder(with: self.cloneOrderWithFields)
            self.cloneOrderWithFields = []
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.performShowAnimation()
    }
    
    // MARK: - ToDo Methods
    func configureUI() {
        self.createOrderButton.setImage(FontUtility.appImageIcon(code: AppIcons.edit.rawValue, textColor: .white, size: CGSize(width: 16, height: 16)), for: .normal)
    }
    
    func resetAnimatedView() {
        self.logoHeightConstraint.constant = 90
        self.logoWidthConstraint.constant = 90
        
        self.createOrderTopConstraint.constant = 200
        self.createOrderButton.alpha = 0
        self.lblOrderWithNoOrganization.alpha = 0
    }
    
    func performShowAnimation() {
        self.logoHeightConstraint.constant = 250
        self.logoWidthConstraint.constant = 250
        
        self.createOrderTopConstraint.constant = 80
        
        UIView.animate(withDuration: 1.0, animations: {
            self.createOrderButton.alpha = 1
            self.lblOrderWithNoOrganization.alpha = 1
            self.view.layoutIfNeeded()
        }) { (animated) in }
    }
    
    // MARK: - Action Methods
    @objc func notificationAction(_ sender: UIBarButtonItem) {
        let notificationController = NotificationViewController()
        self.navigationController?.pushViewController(notificationController, animated: true)
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action Methods
    @IBAction func loginBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    @IBAction func createOrderAction(_ sender: UIButton) {
        self.createNewOrder()
    }
    
    func createNewOrder(with formFields: [FormFieldModel]? = nil) {
        let controller = NewOrderFormTableViewController()
        controller.formFields = formFields ?? []
        
        let formController = UINavigationController(rootViewController: controller)
        formController.modalPresentationStyle = .fullScreen
        self.present(formController, animated: true, completion: nil)
    }
    
    //MARK: - Api Methods
    func fetchOrders(with tag: String, completion: @escaping ([Order]?, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.listOrder.rawValue,
            Constants.API.key: "1c2bc3708d69c02412c9bdbae96967a1d77bbc24",
            Constants.API.customerId: UserConstant.shared.userModel.id,
            Constants.API.orderStatus: tag
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.niharBaseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let orders: [Order] = try! JSONDecoder().decode([Order].self, from: jsonData)
                    completion(orders, nil)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
}

extension OrdersViewController: TabbedViewDataSource {
    func tabTitles() -> [String] {
        return [
            "IN PROCESS",
            "PREVIOUS ORDERS",
            "INBOX"
        ]
    }
    
    func reloadContainer(for tab: TabModel, index: Int) -> UIView {
        if UserConstant.shared.userModel != nil {
            self.orderData = []
            self.selectedTabIndex = index
            
            var orderStatus = ""
            if index == 0 {
                orderStatus = "A"
            } else if index == 1 {
                orderStatus = "C"
            } else if index == 2 {
                orderStatus = "I"
            }
            
            self.setUpTableView()
            
            self.alertLoader = self.showAlertLoader()
            self.fetchOrders(with: orderStatus) { (orders, apiStatus) in
                DispatchQueue.main.async {
                    self.alertLoader?.dismiss(animated: false, completion: nil)
                    if let ordersData = orders {
                        self.orderData = ordersData
                        self.tableView?.backgroundView = nil
                    } else {
                        self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                        self.tableView?.backgroundView = self.emptyWidget()
                    }
                    self.tableView?.reloadData()
                }
            }
            
            return self.tableView!
        }
        
        return self.emptyWidget()
    }
    
    func setUpTableView() {
        self.tableView = UITableView()
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
        self.tableView?.separatorColor = UIColor.clear
        
        self.tableView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
        
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 300
        
        self.tableView?.register(UINib(nibName: InProgressOrdersTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InProgressOrdersTableViewCell.identifier)
        self.tableView?.register(UINib(nibName: CompletedOrderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CompletedOrderTableViewCell.identifier)
        self.tableView?.reloadData()
    }
    
    func emptyWidget() -> EmptyOrderView {
        let emptyOrdersView = EmptyOrderView()
        emptyOrdersView.delegate = self
        return emptyOrdersView
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.selectedTabIndex {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressOrdersTableViewCell.identifier) as? InProgressOrdersTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(InProgressOrdersTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            let order = self.orderData[indexPath.row]
            cell.updateData(with: order)
            cell.selectionStyle = .none
            
            cell.btnNotificationAction = {
                self.navigateToNotification(with: order)
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletedOrderTableViewCell.identifier) as? CompletedOrderTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(CompletedOrderTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            let order = self.orderData[indexPath.row]
            cell.updateData(with: order)
            cell.selectionStyle = .none
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressOrdersTableViewCell.identifier) as? InProgressOrdersTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(InProgressOrdersTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            let order = self.orderData[indexPath.row]
            cell.updateData(with: order)
            cell.selectionStyle = .none
            
            cell.btnNotificationAction = {
                self.navigateToNotification(with: order)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.selectedTabIndex {
        case 0:
            let order = self.orderData[indexPath.row];
            self.navigateToOrderDetails(with: order, orderStatus: .awaiting)
            break
        case 1:
            let order = self.orderData[indexPath.row];
            self.navigateToOrderDetails(with: order, orderStatus: .completed)
            break
        case 2:
            let order = self.orderData[indexPath.row];
            self.navigateToOrderDetails(with: order, orderStatus: .inProgress)
            break
        default:
            print("Do nothing here")
        }
    }
    
    func navigateToNotification(with order: Order) {
        let notificationController = NotificationViewController()
        notificationController.orderId = order.orderId
        self.navigationController?.pushViewController(notificationController, animated: true)
    }
    
    func navigateToOrderDetails(with order: Order, orderStatus: OrderStatus) {
        let orderDetailsController = OrderDetailsViewController()
        orderDetailsController.order = order
        orderDetailsController.orderStatus = orderStatus
        orderDetailsController.delegate = self
        
        self.navigationController?.pushViewController(orderDetailsController, animated: true)
    }
}

extension OrdersViewController: EmptyOrderViewActionsProtocol {
    func bookACourier() {
        self.createNewOrder()
    }
    
    func trackMyOrder() {
        self.tabbedView.setSelectedIndex(tabIndex: 2)
    }
}

extension OrdersViewController: NewOrderCloningProtocol {
    func cloneOrder(with formFields: [FormFieldModel]) {
        self.cloneOrderWithFields = formFields
    }
}

