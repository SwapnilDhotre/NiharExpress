//
//  TrackOrderViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/9/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import GoogleMaps

enum MarkerType {
    case driverMarker
    case pickUpMarker
    case dropMarker
}

class TrackOrderViewController: UIViewController {
    var order: Order!
    var timer: Timer?
    
    var driversZoomMode: Bool = false
    
    @IBOutlet weak var btnToggleMapView: UIButton!
    @IBOutlet weak var gmsMap: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.timer?.invalidate()
    }
    
    func configureUI() {
        self.showAndUpdateNavigationBar(with: "Order \(order.orderNo)", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnPressed(_:)))
        
        self.tabBarController?.tabBar.isHidden = true
        self.updateDriversLocation()
        self.timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.updateDriversLocation), userInfo: nil, repeats: true)
        
        self.updateBtnView(sender: self.btnToggleMapView, flag: 0)
    }
    
    @objc func updateDriversLocation() {
        self.fetchDriversLocation { (driverInfo, apiStatus) in
            DispatchQueue.main.async {
                if let info = driverInfo {
                    self.setUpMap(driverInfo: info)
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                }
            }
        }
    }
    
    func setUpMap(driverInfo: DriverInfo) {
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
        
        bounds = bounds.includingCoordinate(self.placeMarker(address: order.pickUp, markerType: .pickUpMarker).position)
        for (index, deliveryAddr) in order.delivery.enumerated() {
            bounds = bounds.includingCoordinate(self.placeMarker(index: index, address: deliveryAddr, markerType: .dropMarker).position)
        }

        bounds = bounds.includingCoordinate(self.addPinAtLocation(coordinate: CLLocationCoordinate2D(latitude: driverInfo.latitude, longitude: driverInfo.longitude), title: self.order.driverName, mobileNo: self.order.driveMobileNo, address: "", isDriversLocation: true).position)

//        self.gmsMap.animate(with: GMSCameraUpdate.fit(bounds))
        
        let sessionManager = GoogleMapSessionManager()
        let start = CLLocationCoordinate2D(latitude: driverInfo.latitude, longitude: driverInfo.longitude)
        var end: CLLocationCoordinate2D!
        
        if order.pickUp.isComplete == "N" {
            let lat: Double = NSString(string: order.pickUp.lat).doubleValue
            let long: Double = NSString(string: order.pickUp.long).doubleValue
            end = CLLocationCoordinate2D(latitude: lat, longitude: long)
        } else {
            for location in order.delivery {
                if location.isComplete == "N" {
                    let lat: Double = NSString(string: location.lat).doubleValue
                    let long: Double = NSString(string: location.long).doubleValue
                    end = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    break
                }
            }
        }
        
        sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, error) in
            
            if let error = error {
                print("Something went wrong, abort drawing!\nError: \(error)")
            } else {
                // Create a GMSPolyline object from the GMSPath
                let polyline = GMSPolyline(path: path!)
                
                // Add the GMSPolyline object to the mapView
                polyline.map = self.gmsMap
                
                // Configure polyline
                polyline.strokeColor = #colorLiteral(red: 0.937254902, green: 0.1882352941, blue: 0.1294117647, alpha: 1)
                polyline.strokeWidth = 3
                
                if self.driversZoomMode {
                    var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
                    bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: driverInfo.latitude, longitude: driverInfo.longitude))
                    self.gmsMap.animate(with: GMSCameraUpdate.fit(bounds))
                } else {
                    
                    // Move the camera to the polyline
                    let bounds = GMSCoordinateBounds(path: path!)
                    let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
                    self.gmsMap.animate(with: cameraUpdate)
                }
            }
            
        })
    }
    
    func placeMarker(index: Int? = nil, address: OrderAddress, markerType: MarkerType) -> GMSMarker {
        let lat: Double = NSString(string: address.lat).doubleValue
        let long: Double = NSString(string: address.long).doubleValue
        
        let marker = self.addPinAtLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), title: address.userName, mobileNo: address.mobileNo, address: address.address, isDriversLocation: false)
        
        let image: UIImage!
        switch markerType {
        case .pickUpMarker:
            image = UIImage(named: "pickup-png")?.resizeImage(targetSize: CGSize(width: 60, height: 60))
            break
        case .driverMarker:
            image = UIImage(named: "driver-png")?.resizeImage(targetSize: CGSize(width: 60, height: 60))
            break
        case .dropMarker:
            image = UIImage(named: "drop-png")?.resizeImage(targetSize: CGSize(width: 60, height: 60))
            break
        }
        
        if index != nil {
            marker.title = "Drop \(index! + 1)"
            let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            markerView.imgView.image = image
            markerView.lblTitle.text = "Drop \(index! + 1)"
            marker.iconView = markerView
        } else {
            marker.title = "Pick Up"
            let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            markerView.imgView.image = image
            markerView.lblTitle.text = "Pick Up"
            marker.iconView = markerView
        }
        
        return marker
    }
    
    @discardableResult func addPinAtLocation(coordinate: CLLocationCoordinate2D, title: String, mobileNo: String, address: String, isDriversLocation: Bool) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = title
        marker.map = self.gmsMap
        marker.snippet = "\(mobileNo)\n\(address)"
        
        if isDriversLocation {
            let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            markerView.imgView.image = UIImage(named: "driver-png")?.resizeImage(targetSize: CGSize(width: 60, height: 60))
            markerView.lblTitle.text = "Driver"
            marker.iconView = markerView
        }
        
        return marker
    }
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnToggleMapView(_ sender: UIButton) {
        sender.tag = sender.tag == 0 ? 1 : 0
        self.updateBtnView(sender: sender, flag: sender.tag)
    }
    
    func updateBtnView(sender: UIButton, flag: Int) {
        if flag == 0 {
            sender.setImage(UIImage(named: "direction_icon"), for: .normal)
            self.driversZoomMode = false
        } else {
            sender.setImage(UIImage(named: "logo"), for: .normal)
            self.driversZoomMode = true
        }
        self.updateDriversLocation()
    }
    
    func fetchDriversLocation(completion: @escaping ((DriverInfo?, APIStatus?) -> Void)) {
        let params: Parameters = [
            Constants.API.method: Constants.MethodType.getLocation.rawValue,
            Constants.API.key: "f2003afd682efb81485c96a291b88ccc60a596e6",
            Constants.API.orderId: self.order.orderId
        ]
        
        APIManager.shared.executeDataRequest(urlString: URLConstant.baseURL, method: .get, parameters: params, headers: nil) { (responseData, error) in
            APIManager.shared.parseResponse(responseData: responseData) { (responseData, apiStatus) in
                if let response = responseData?.first, let jsonData = try? JSONSerialization.data(withJSONObject: response) {
                    let info: DriverInfo = try! JSONDecoder().decode(DriverInfo.self, from: jsonData)
                    completion(info, nil)
                } else {
                    completion(nil, apiStatus)
                }
            }
        }
    }
}
