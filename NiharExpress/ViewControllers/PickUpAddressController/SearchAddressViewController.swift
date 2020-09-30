//
//  PickUpAddressViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 27/09/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

protocol SearchAddressDelegate {
    func previousAddressSelected(userAddressModel: UserAddressModel, indexPath: IndexPath)
    func newLocationPicked(address: AddressModel, indexPath: IndexPath)
}

class SearchAddressViewController: UIViewController {
    var indexPath: IndexPath!
    
    var userAddressModels: [UserAddressModel] = []
    var searchAddresses: [AddressModel] = []
    
    @IBOutlet weak var txtAddressSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var btnPickAddress: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertLoader: UIAlertController?
    
    var searchStarted: Bool = false
    
    var delegate: SearchAddressDelegate?
    
    var addressSelected: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    func configureUI() {
        
        self.showAndUpdateNavigationBar(with: "Address Selection", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
        
        self.btnClearSearch.setTitle(AppIcons.cross.rawValue, for: .normal)
        self.btnClearSearch.setTitleColor(.gray, for: .normal)
        self.btnClearSearch.titleLabel?.font = FontUtility.niharExpress(size: 14)
        
        self.txtAddressSearch.addTarget(self, action: #selector(self.textEditing(_:)), for: .editingChanged)
        
        let doneBarUttonn = UIButton(type: .custom)
        doneBarUttonn.setTitle("Done", for: .normal)
        doneBarUttonn.setTitleColor(ColorConstant.themePrimary.color, for: .normal)
        doneBarUttonn.addTarget(self, action: #selector(self.doneBarButtonAction(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBarUttonn)
        
        self.btnPickAddress.setImage(UIImage.fontAwesomeIcon(code: FontAwesome.mapMarkerAlt.rawValue, style: .solid, textColor: ColorConstant.themePrimary.color, size: CGSize(width: 24, height: 24)), for: .normal)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: SearchAddressTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchAddressTableViewCell.identifier)
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
    
    // MARK: - Action Methods
    @IBAction func btnClearSearchAction(_ sender: UIButton) {
        self.searchStarted = false
        self.txtAddressSearch.text = ""
        self.tableView.reloadData()
    }
    
    @IBAction func btnSelectLocationAction(_ sender: UIButton) {
        let pickAddressConstroller = PickAddressViewController()
        pickAddressConstroller.pickAddress = { (addressModel) in
            DispatchQueue.main.async {
                self.delegate?.newLocationPicked(address: addressModel, indexPath: self.indexPath)
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.navigationController?.pushViewController(pickAddressConstroller, animated: true)
    }
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneBarButtonAction(_ sender: UIButton) {
        if let addressModel = self.addressSelected as? UserAddressModel {
            self.delegate?.previousAddressSelected(userAddressModel: addressModel, indexPath: self.indexPath)
        } else if let addressModel = self.addressSelected as? AddressModel {
            self.delegate?.newLocationPicked(address: addressModel, indexPath: self.indexPath)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textEditing(_ textField: UITextField) {
        if textField.text! == "" {
            self.searchStarted = false
        } else {
            self.searchStarted = true
            
            self.searchResults(for: textField.text!, completion: { (models, apiStatus) in
                DispatchQueue.main.async {
                    self.alertLoader?.dismiss(animated: false, completion: nil)
                    if let status = apiStatus {
                        self.showAlert(withMsg: status.message)
                    } else {
                        self.searchAddresses = models
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - API Methods
    func searchResults(for text: String, completion: @escaping (([AddressModel], APIStatus?) -> Void)) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getLocationAutocomplete.rawValue,
            Constants.API.key: "19885432d6ac3d08d46ca1543b66c685d580b738",
            Constants.API.term: text
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData?.first, let jsonAddresses = response["data"], let jsonData = try? JSONSerialization.data(withJSONObject: jsonAddresses) {
                    let models: [AddressModel] = try! JSONDecoder().decode([AddressModel].self, from: jsonData)
                    completion(models, nil)
                } else {
                    completion([], apiStatus)
                }
            }
        }
    }
    
    func fetchPreviousAddresses(completion: @escaping (([UserAddressModel], APIStatus?) -> Void)) {
        
        var params: Parameters = [
            Constants.API.method: Constants.MethodType.getSuggestedAddress.rawValue,
            Constants.API.key: "c81988890f85c5dda3b0a48606e25edbe03f3a0e"
        ]
        
        if (UserConstant.shared.userModel != nil) {
            params[Constants.API.customerId] = UserConstant.shared.userModel.id
        }
        
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

extension SearchAddressViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchStarted {
            return self.searchAddresses.count
        } else {
            return self.userAddressModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        
        if self.searchStarted {
            cell.textLabel?.text = self.searchAddresses[indexPath.row].address
        } else {
            let user = self.userAddressModels[indexPath.row]
            cell.textLabel?.text = "\(user.name)\n\(user.address)\n\(user.mobileNo)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchStarted {
            self.addressSelected = self.searchAddresses[indexPath.row]
            self.searchAddresses = []
            self.searchAddresses.append(self.addressSelected as! AddressModel)
        } else {
            self.addressSelected = self.userAddressModels[indexPath.row]
            self.userAddressModels = []
            self.userAddressModels.append(self.addressSelected as! UserAddressModel)
        }
        self.updateAddressSelected()
    }
    
    func updateAddressSelected() {
        if let address = self.addressSelected as? AddressModel {
            self.txtAddressSearch.text = address.address
        } else if let address = self.addressSelected as? UserAddressModel {
            self.txtAddressSearch.text = address.address
        }
        self.tableView.reloadData()
    }
}
