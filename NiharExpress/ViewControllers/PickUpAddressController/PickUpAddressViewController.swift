//
//  PickUpAddressViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 27/09/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class PickUpAddressViewController: UIViewController {
    
    var userAddressModels: [UserAddressModel] = []
    
    @IBOutlet weak var txtAddressSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var btnPickAddress: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertLoader: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    func configureUI() {
        
        self.btnClearSearch.setTitle(AppIcons.cross.rawValue, for: .normal)
        self.btnClearSearch.setTitleColor(.gray, for: .normal)
        self.btnClearSearch.titleLabel?.font = FontUtility.niharExpress(size: 14)
        
        self.btnPickAddress.setImage(UIImage.fontAwesomeIcon(code: FontAwesome.mapMarkerAlt.rawValue, style: .solid, textColor: ColorConstant.themePrimary.color, size: CGSize(width: 24, height: 24)), for: .normal)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.alertLoader = self.showAlertLoader()
        self.fetchPreviousAddresses { (models, apiStatus) in
            DispatchQueue.main.async {
                self.alertLoader?.dismiss(animated: false, completion: nil)
                if let status = apiStatus {
                    self.showAlert(withMsg: status.message)
                } else {
                    self.userAddressModels = models
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func btnClearSearchAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSelectLocationAction(_ sender: UIButton) {
    }
    
    // MARK: - API Methods
    func fetchPreviousAddresses(completion: @escaping (([UserAddressModel], APIStatus?) -> Void)) {
        
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getSuggestedAddress.rawValue,
            Constants.API.key: "c81988890f85c5dda3b0a48606e25edbe03f3a0e",
            Constants.API.customerId: "49"
        ]
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData?.first, let jsonAddresses = response["address"], let jsonData = try? JSONSerialization.data(withJSONObject: jsonAddresses) {
                    let models: [UserAddressModel] = try! JSONDecoder().decode([UserAddressModel].self, from: jsonData)
                    completion(models, nil)
                } else {
                    completion([], apiStatus)
                }
            }
        }
    }
}

extension PickUpAddressViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userAddressModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user = self.userAddressModels[indexPath.row]
        cell.textLabel?.text = "\(user.name)\n\(user.address)\n\(user.mobileNo)"
        cell.textLabel?.numberOfLines = 0
        
        cell.selectionStyle = .none
        
        return cell
    }
}
