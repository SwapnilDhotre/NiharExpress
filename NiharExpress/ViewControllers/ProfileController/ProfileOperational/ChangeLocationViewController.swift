//
//  ChangeLocationViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/10/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit


class ChangeLocationViewController: UIViewController {
    
    var order: Order!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var cities: [City] = []
    
    var locationModified: (() -> Void)?
    
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
        
        self.fetchLocations { (locations, apiStatus) in
            if let cities = locations {
                DispatchQueue.main.async {
                    if let city = UserConstant.shared.city {
                        (cities.filter { $0.id == city.id }).first?.isSelected = true
                    } else {
                        cities.first?.isSelected = true
                    }
                    self.cities = cities
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
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        if let city = (self.cities.filter { $0.isSelected }).first {
            UserConstant.shared.city = city
            self.dismiss(animated: false) {
                self.locationModified?()
            }
        }
    }
    
    func fetchLocations(completion: @escaping ([City]?, APIStatus?) -> Void) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.listCity.rawValue,
            Constants.API.key: "8633fe0483a285b46928157103a77d93b5f4638d"
        ]
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let reasons: [City] = try! JSONDecoder().decode([City].self, from: jsonData)
                    completion(reasons, apiStatus)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
}

extension ChangeLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioTableViewCell.identifier) as? RadioTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(RadioTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        let city = self.cities[indexPath.row]
        cell.isRadioSelected = city.isSelected
        cell.lblTitle.text = city.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cities.forEach { (reason) in
            reason.isSelected = false
        }
        
        self.cities[indexPath.row].isSelected = true
        self.tableView.reloadData()
    }
}

