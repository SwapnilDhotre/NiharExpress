//
//  ProfileViewController.swift
//  NiharExpress
//
//  Created by Swapnil Dhotre on 02/07/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

struct ProfileInfo {
    var icon: AppIcons
    var title: String
    var subTitle: String
    var trailingString: String
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblLoginButton: DesignableButton!
    @IBOutlet weak var registerButton: DesignableButton!
    @IBOutlet weak var createOrderButton: DesignableButton!
    @IBOutlet weak var lblOrderWithNoOrganization: UILabel!
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var createOrderTopConstraint: NSLayoutConstraint!
    
    var profileData: [ProfileInfo] = []
    @IBOutlet weak var loginRegisterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserConstant.shared.userModel == nil {
             self.showAndUpdateNavigationBar(with: "SAME DAY DELIVERY PARTNER", withShadow: true, isHavingBackButton: false, actionController: self, backAction: nil)
             self.resetAnimatedView()
             self.loginRegisterView.isHidden = false
         } else {
             self.configureTableUI()
             self.loginRegisterView.isHidden = true
             self.hideNavigationBar()
             self.tableView.reloadData()
         }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserConstant.shared.userModel == nil {
            self.performShowAnimation()
        }
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
    
    func configureTableUI() {
        self.lblUserName.text = UserConstant.shared.userModel.firstName + " " + UserConstant.shared.userModel.lastName
        self.lblContactNo.text = UserConstant.shared.userModel.mobileNo
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        self.profileData = [
            ProfileInfo(icon: .profile, title: "Personal Details", subTitle: "\(self.lblUserName.text ?? ""), \(UserConstant.shared.userModel.emailId ?? "")", trailingString: ""),
            ProfileInfo(icon: .location, title: "Change Region", subTitle: "", trailingString: UserConstant.shared.city?.name ?? "Mumbai"),
            ProfileInfo(icon: .statistic, title: "Statistics", subTitle: "", trailingString: ""),
            ProfileInfo(icon: .refEarn, title: "Refer n Earn", subTitle: "", trailingString: ""),
            ProfileInfo(icon: .logout, title: "Log out", subTitle: "", trailingString: ""),
        ]
        
        self.tableView.reloadData()
    }
    
    // MARK: - Action Methods
    @IBAction func loginBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    @IBAction func createOrderAction(_ sender: UIButton) {
        let controller = NewOrderFormTableViewController()
        let formController = UINavigationController(rootViewController: controller)
        formController.modalPresentationStyle = .fullScreen
        self.present(formController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as? ProfileTableViewCell else {
            assertionFailure("Couldn't dequeue:>> \(ProfileTableViewCell.identifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        let data = self.profileData[indexPath.row]
        cell.updateData(with: data.icon.rawValue, title: data.title, subTitle: data.subTitle, trailing: data.trailingString)
        
        if data.icon == .refEarn {
            cell.icon.image = UIImage(named: "refEarn")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.profileData[indexPath.row].icon {
        case .location:
            let locationController = ChangeLocationViewController()
            locationController.modalPresentationStyle = .overCurrentContext
            locationController.locationModified = {
                DispatchQueue.main.async {
                    self.configureTableUI()
                }
            }
            self.present(locationController, animated: false, completion: nil)
        case .logout:
            UserDefaultManager.shared.clear()
            UserConstant.shared.reset()
            self.viewWillAppear(true)
            self.viewDidAppear(true)
        default:
            print("Not handled here")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
