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
    var mapLocations: [MapLocation] = []
    var timer: Timer?
    
    var driversZoomMode: Bool = false
    var driverInfo: DriverInfo?
    
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
                    self.driverInfo = info
                    self.setUpMap(driverInfo: info)
                } else {
                    self.showAlert(withMsg: apiStatus?.message ?? "Something went wrong")
                    self.setUpMap(driverInfo: nil)
                }
            }
        }
    }
    
    func setUpMap(driverInfo: DriverInfo?) {
        self.placeAllMarkers(driverInfo: driverInfo)
        
        guard let driverInfo = driverInfo else {
            return
        }
        
        let sessionManager = GoogleMapSessionManager()
        let start = CLLocationCoordinate2D(latitude: driverInfo.latitude, longitude: driverInfo.longitude)
        var end: CLLocationCoordinate2D!
        
        for location in self.mapLocations {
            if !location.isComplete {
                end = location.coordinate
                break
            }
        }
        
        sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, distance, duration, error) in
            
            if let error = error {
                print("Something went wrong, abort drawing!\nError: \(error)")
            } else {
                self.gmsMap.clear()
                self.placeAllMarkers(driverInfo: driverInfo)
                
                // Create a GMSPolyline object from the GMSPath
                let polyline = GMSPolyline(path: path!)
                
                // Add the GMSPolyline object to the mapView
                polyline.map = self.gmsMap
                
                // Configure polyline
                polyline.strokeColor = #colorLiteral(red: 0.937254902, green: 0.1882352941, blue: 0.1294117647, alpha: 1)
                polyline.strokeWidth = 3
                
//                self.placeInfoWindow(path: path!, distance: distance!, duration: duration!)
                
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
    
    func placeInfoWindow(path: GMSPath, distance: String, duration: String) {
        let pathDraw = GMSPath(fromEncodedPath: path.encodedPath())!
        let pointsCount = pathDraw.count()
           let midpoint = pathDraw.coordinate(at: pointsCount)

           DispatchQueue.main.async {
               self.addMarkerPin(corrdinate: midpoint, distance: distance, duration: duration)
           }
    }
    
    func addMarkerPin(corrdinate: CLLocationCoordinate2D, distance: String, duration: String) {
        let marker = GMSMarker()
        marker.position = corrdinate

        let infoWindow = InfoWindow()
        infoWindow.lblTitle.text = distance
        infoWindow.lblInfo.text = distance
        
        marker.icon = UIImage(view: infoWindow)
        marker.map = self.gmsMap
        marker.infoWindowAnchor = CGPoint(x: -1900 , y: -2000)
    }
    
    func placeAllMarkers(driverInfo: DriverInfo?) {
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
        
        for (index, location) in mapLocations.enumerated() {
            bounds = bounds.includingCoordinate(self.placeMarker(index: index, location: location, markerType: location.type).position)
        }
        
        if driverInfo != nil {
            bounds = bounds.includingCoordinate(self.addPinAtLocation(coordinate: CLLocationCoordinate2D(latitude: driverInfo!.latitude, longitude: driverInfo!.longitude), title: self.order.driverName, mobileNo: self.order.driveMobileNo, address: "", isDriversLocation: true).position)
        } else {
            self.gmsMap.animate(with: GMSCameraUpdate.fit(bounds))
        }
    }
    
    func placeMarker(index: Int, location: MapLocation, markerType: LocationType?) -> GMSMarker {
        let marker = self.addPinAtLocation(coordinate: location.coordinate, title: location.name, mobileNo: location.mobileNo, address: location.address, isDriversLocation: false)
        
        let image: UIImage!
        if let type = markerType {
            switch type {
            case .pickUp:
                image = UIImage(named: "pickup-png")?.resizeImage(targetSize: CGSize(width: 60, height: 60))
                break
                
            case .delivery:
                image = UIImage(named: "drop-png")?.resizeImage(targetSize: CGSize(width: 60, height: 60))
                break
            }
        } else {
            image = UIImage(named: "driver-png")?.resizeImage(targetSize: CGSize(width: 60, height: 60))
        }
        
        if index == 0 {
            marker.title = "Pick Up"
            let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            markerView.imgView.image = image
            markerView.lblTitle.text = "Pick Up"
            marker.iconView = markerView
        } else {
            marker.title = "Drop \(index)"
            let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            markerView.imgView.image = image
            markerView.lblTitle.text = "Drop \(index)"
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
        if let info = driverInfo {
            self.setUpMap(driverInfo: info)
        }
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
