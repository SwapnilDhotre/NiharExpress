//
//  OrdersViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import ESPullToRefresh

extension Notification.Name {
    static let fromNewOrderForm = Notification.Name("fromNewOrderForm")
}

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
    
    var isReturnedFromForm: Bool = false
    var cloneOrderWithFields: [FormFieldModel] = []
    
    var notificationBarButton: UIButton!
    
    var cursor = 0
    var pages = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        
        if !UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            let walkthroughViewController = WalkThroughViewController()
            walkthroughViewController.modalPresentationStyle = .fullScreen
            self.present(walkthroughViewController, animated: true, completion: nil)
        }

        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.returnedFromForm(notification:)),
            name: .fromNewOrderForm,
            object: nil)
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
                
                self.notificationBarButton = self.addNotificationBarButton(actionController: self, notificationAction: #selector(self.notificationAction(_:)))
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
        if let barBtn = self.notificationBarButton {
            Util.setNotificationCount(btn: barBtn)
        }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performShowAnimation()
        }
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
    
    @objc private func returnedFromForm(notification: NSNotification) {
        self.isReturnedFromForm = true
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
        var params: Parameters = [
            Constants.API.method: Constants.MethodType.listOrder.rawValue,
            Constants.API.key: "1c2bc3708d69c02412c9bdbae96967a1d77bbc24",
            Constants.API.customerId: UserConstant.shared.userModel.id,
            Constants.API.orderStatus: tag
        ]
        
        if tag == "I" || tag == "C" {
            params["limit"] = "8"
            params["cursor"] = "\(self.cursor)"
        }
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    if let firstOrder = response.first {
                        if let noOfPages = firstOrder["pages"] as? Int {
                            self.pages = noOfPages
                        }
                    }
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
            
            self.setUpTableView()
            
            if self.isReturnedFromForm {
                self.isReturnedFromForm = false;
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cursor = 0
                    self.fetchData(for: index, isFromPullDownRefresh: false, completion: nil)
                }
            } else {
                self.cursor = 0
                self.fetchData(for: index, isFromPullDownRefresh: false, completion: nil)
            }
            
            return self.tableView!
        }
        
        return self.emptyWidget()
    }
    
    func fetchData(for index: Int, isFromPullDownRefresh: Bool, completion: (() -> Void)?) {
        var orderStatus = ""
        if index == 0 {
            orderStatus = "A"
        } else if index == 1 {
            orderStatus = "C"
        } else if index == 2 {
            orderStatus = "I"
        }
        
        if !isFromPullDownRefresh && index == 0 {
            self.alertLoader = self.showAlertLoader()
        } else {
            if (index == 1 || index == 2) && cursor == 0 {
                self.alertLoader = self.showAlertLoader()
            }
        }
        
        self.fetchOrders(with: orderStatus) { (orders, apiStatus) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                completion?()
                if let ordersData = orders {
                    if index == 0 {
                        self.orderData = ordersData.reversed()
                    } else {
                        self.cursor += 1
                        self.orderData.append(contentsOf: ordersData.reversed())
                    }
                    self.tableView?.backgroundView = nil
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                    self.tableView?.backgroundView = self.emptyWidget()
                }
                self.tableView?.reloadData()
            }
        }
    }
    
    func setUpTableView() {
        self.tableView = UITableView()
        
        self.tableView?.dataSource = self
        self.tableView?.prefetchDataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
        self.tableView?.separatorColor = UIColor.clear
        
        self.tableView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
        
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 300
        
        self.tableView?.register(UINib(nibName: InProgressOrdersTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InProgressOrdersTableViewCell.identifier)
        self.tableView?.register(UINib(nibName: CompletedOrderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CompletedOrderTableViewCell.identifier)
        self.tableView?.register(UINib(nibName: LoadingCellTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LoadingCellTableViewCell.identifier)

        self.tableView?.reloadData()
        
        self.tableView?.es.addPullToRefresh {
            [unowned self] in
            
            self.orderData = []
            self.cursor = 0
            self.fetchData(for: self.selectedTabIndex, isFromPullDownRefresh: true, completion: { [unowned self] in
                self.tableView?.es.stopPullToRefresh()
            })
        }
    }
    
    func emptyWidget() -> EmptyOrderView {
        let emptyOrdersView = EmptyOrderView()
        emptyOrdersView.delegate = self
        return emptyOrdersView
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedTabIndex == 0 {
            return self.orderData.count
        } else {
            if self.cursor + 1 < self.pages {
                return self.orderData.count > 0 ? self.orderData.count + 1 : 0
            } else {
                return self.orderData.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedTabIndex != 0 {
            if isLoadingCell(for: indexPath) {
                self.fetchData(for: self.selectedTabIndex, isFromPullDownRefresh: false, completion: nil)
            }
            
            guard self.orderData.count + 1 > indexPath.row  else {
                print("Array index outof bounds")
                return UITableViewCell()
            }
        }
        print("Indexpath:>>\(indexPath)")
        
        switch self.selectedTabIndex {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressOrdersTableViewCell.identifier) as? InProgressOrdersTableViewCell else {
                assertionFailure("Couldn't dequeue:>> \(InProgressOrdersTableViewCell.identifier)")
                return UITableViewCell()
            }
            
            if self.orderData.count > indexPath.row {
                let order = self.orderData[indexPath.row]
                cell.updateData(with: order)
                cell.selectionStyle = .none
                
                cell.btnNotificationAction = {
                    self.navigateToNotification(with: order)
                }
            } else {
                print("Caught in data reload")
            }
            return cell
        case 1:
            
            if isLoadingCell(for: indexPath) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCellTableViewCell.identifier) as? LoadingCellTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(LoadingCellTableViewCell.identifier)")
                    return UITableViewCell()
                }
                cell.activityIndicator.startAnimating()
                return cell
            } else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletedOrderTableViewCell.identifier) as? CompletedOrderTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(CompletedOrderTableViewCell.identifier)")
                    return UITableViewCell()
                }
                
                let order = self.orderData[indexPath.row]
                cell.updateData(with: order)
                cell.selectionStyle = .none
                
                cell.btnNotificationAction = {
                    self.navigateToNotification(with: order)
                }
                
                return cell
            }
        case 2:
            if isLoadingCell(for: indexPath) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCellTableViewCell.identifier) as? LoadingCellTableViewCell else {
                    assertionFailure("Couldn't dequeue:>> \(LoadingCellTableViewCell.identifier)")
                    return UITableViewCell()
                }
                cell.activityIndicator.startAnimating()
                return cell
            } else {
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
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.selectedTabIndex {
        case 0:
            let order = self.orderData[indexPath.row];
            var status: OrderStatus = .awaiting
            if order.orderStatus == "Assigned" {
                status = .assigned
            } else if order.orderStatus == "Pickup" {
                status = .pickUp
            } else if order.orderStatus == "Delivery In Progress" {
                status = .deliveryInProgress
            }
            
            self.navigateToOrderDetails(with: order, orderStatus: status)
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
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        if indexPaths.contains(where: isLoadingCell) && self.selectedTabIndex != 0 {
//            self.fetchData(for: self.selectedTabIndex, isFromPullDownRefresh: false, completion: nil)
//        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == self.orderData.count
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
