//
//  NotificationViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class NotificationModel: Codable {
    var id: String
    var title: String
    var date: Date
    var isRead: String
    
    init(id: String, title: String, date: Date, isRead: String) {
        self.id = id
        self.title = title
        self.date = date
        self.isRead = isRead
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "notification_id"
        case title = "notification"
        case date = "timestamp"
        case isRead = "is_read"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id: String = try container.decode(String.self, forKey: .id)
        let title: String = try container.decode(String.self, forKey: .title)
        let dateString: String = try container.decode(String.self, forKey: .date)
        let date = dateString.toDate(withFormat: "dd-MM-yyyy hh:mm:ss a")!
        let isRead: String = try container.decode(String.self, forKey: .isRead)
        
        self.init(id: id, title: title, date: date, isRead: isRead)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.date.toString(withFormat: "dd-MM-yyyy hh:mm:ss a"), forKey: .date)
        try container.encode(self.isRead, forKey: .isRead)
    }
}

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [NotificationModel] = []
    var alertLoader: UIAlertController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showAndUpdateNavigationBar(with: "Notifications", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnPressed(_:)))
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureUI() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: NotificationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotificationTableViewCell.identifier)
        
        self.alertLoader = self.showAlertLoader()
        self.fetchNotification { (notifications, apiStatus) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                if let notifications = notifications {
                    self.notifications = notifications
                    self.tableView.reloadData()
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                }
            }
        }
    }
    
    func fetchNotification(completion: @escaping ([NotificationModel]?, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.listNotification.rawValue,
            Constants.API.key: "41979bf5da2d2bfbae66fda5ac59ed132216b87b",
            Constants.API.customerId: UserConstant.shared.userModel.id
        ]
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let notifications: [NotificationModel] = try! JSONDecoder().decode([NotificationModel].self, from: jsonData)
                    completion(notifications, apiStatus)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier) as? NotificationTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(NotificationTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        cell.lblNotificationDetailed.text = self.notifications[indexPath.row].title
        
        return cell
    }
}
