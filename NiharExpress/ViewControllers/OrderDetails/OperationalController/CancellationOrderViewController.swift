//
//  CancellationOrderViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/8/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class CancellationReason: Codable {
    var id: String
    var title: String
    var isSelected: Bool = false
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id: String = try container.decode(String.self, forKey: .id)
        let title: String = try container.decode(String.self, forKey: .title)
        
        self.init(id: id, title: title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
    }
}

class CancellationOrderViewController: UIViewController {
    
    var order: Order!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var reasons: [CancellationReason] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    func configureUI() {
        self.btnClose.titleLabel?.font = FontUtility.niharExpress(size: 12)
        self.btnClose.setTitle(AppIcons.cross.rawValue, for: .normal)
        self.btnClose.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.spinner.isHidden = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: RadioTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RadioTableViewCell.identifier)
        
        self.fetchCancellationReasons { (cancellationReasons, apiStatus) in
            if let reasons = cancellationReasons {
                DispatchQueue.main.async {
                    reasons.first?.isSelected = true
                    self.reasons = reasons
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.tableView.reloadData()
                }
            } else {
                self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
            }
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelOrderBtnAction(_ sender: UIButton) {
        if let cancellationReason = (self.reasons.filter { $0.isSelected }).first {
            self.cancelOrder(orderId: self.order.orderId, reason: cancellationReason) { (isSuccess, apiStatus) in
                print("APIStatus :\(String(describing: apiStatus))")
            }
        }
    }
    
    func fetchCancellationReasons(completion: @escaping ([CancellationReason]?, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.listReason.rawValue,
            Constants.API.key: "5dcfa2ddd42cdc7424072f74231500e85b24156a"
        ]
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let reasons: [CancellationReason] = try! JSONDecoder().decode([CancellationReason].self, from: jsonData)
                    completion(reasons, apiStatus)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
    
    func cancelOrder(orderId: String, reason: CancellationReason, completion: @escaping (Bool, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.cancelOrder.rawValue,
            Constants.API.key: "1e3677501281253b3539c34bd6772b36d417580c",
            Constants.API.orderId: orderId,
            Constants.API.reason: reason.title
            
        ]
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData {
                    completion(true, nil)
                } else {
                    completion(false, apiStatus)
                }
            }
        }
    }
}

extension CancellationOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioTableViewCell.identifier) as? RadioTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(RadioTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        let reason = self.reasons[indexPath.row]
        cell.isRadioSelected = reason.isSelected
        cell.lblTitle.text = reason.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reasons.forEach { (reason) in
            reason.isSelected = false
        }
        
        self.reasons[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }
}
