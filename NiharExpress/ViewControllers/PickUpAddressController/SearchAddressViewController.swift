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
    func previousAddressSelected(userAddressModel: UserAddressModel)
    func newLocationPicked(address: String)
}

struct SearchAddress {
    var placeID: String
    var title: NSAttributedString
    var subTitle: NSAttributedString
}

class SearchAddressViewController: UIViewController {
    
    var userAddressModels: [UserAddressModel] = []
    var searchAddresses: [SearchAddress] = []
    
    @IBOutlet weak var txtAddressSearch: UITextField!
    @IBOutlet weak var btnClearSearch: UIButton!
    @IBOutlet weak var btnPickAddress: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertLoader: UIAlertController?
    
    var likelyPlaces: [GMSPlace] = []
    
    var placesClient: GMSPlacesClient!
    var placesToken: GMSAutocompleteSessionToken!
    var searchStarted: Bool = false
    
    var delegate: SearchAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    func configureUI() {
        
        self.btnClearSearch.setTitle(AppIcons.cross.rawValue, for: .normal)
        self.btnClearSearch.setTitleColor(.gray, for: .normal)
        self.btnClearSearch.titleLabel?.font = FontUtility.niharExpress(size: 14)
        
        self.txtAddressSearch.addTarget(self, action: #selector(self.textEditing(_:)), for: .editingChanged)
        
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
        
        
        // Setup Google search operation
        placesClient = GMSPlacesClient.shared()
        self.placesToken = GMSAutocompleteSessionToken.init()
    }
    
    // MARK: - Action Methods
    @IBAction func btnClearSearchAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSelectLocationAction(_ sender: UIButton) {
    }
    
    @objc func textEditing(_ textField: UITextField) {
        if textField.text! == "" {
            self.searchStarted = false
        } else {
            self.searchStarted = true
            
            self.searchResults(for: textField.text!)
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - API Methods
    func searchResults(for text: String) {
        // Create a type filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        placesClient?
            .findAutocompletePredictions(fromQuery: text,
                                         filter: filter,
                                         sessionToken: self.placesToken,
                                         callback: { (results, error) in
                                            if let error = error {
                                                print("Autocomplete error: \(error)")
                                                return
                                            }
                                            if let results = results {
                                                
                                                self.searchAddresses = []
                                                for result in results {
                                                    self.searchAddresses.append(SearchAddress(placeID: result.placeID, title: result.attributedPrimaryText, subTitle: result.attributedSecondaryText ?? NSAttributedString()))
                                                }
                                            }
            })
    }
    
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
            cell.textLabel?.attributedText = self.searchAddresses[indexPath.row].title
            cell.detailTextLabel?.attributedText = self.searchAddresses[indexPath.row].subTitle
        } else {
            let user = self.userAddressModels[indexPath.row]
            cell.textLabel?.text = "\(user.name)\n\(user.address)\n\(user.mobileNo)"
        }
        
        return cell
    }
}
