//
//  PickAddressViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 7/15/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class AddressModel: Codable {
    var id: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    
    init(id: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.address = address
        self.coordinate = coordinate
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case address = "address"
        case latitude = "lattitude"
        case longitude = "longitude"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        let id: String = (try? container.decode(String.self, forKey: .id)) ?? ""
        let address: String = (try? container.decode(String.self, forKey: .address)) ?? ""
        let latitude: Double = NSString(string: (try? container.decode(String.self, forKey: .latitude)) ?? "0").doubleValue
        let longitude: Double = NSString(string: (try? container.decode(String.self, forKey: .longitude)) ?? "0").doubleValue
        
        self.init(id: id, address: address, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.coordinate.latitude, forKey: .latitude)
        try container.encode(self.coordinate.longitude, forKey: .longitude)
    }
}

class PickAddressViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    var coordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var imageViiew: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    var pickAddress: ((AddressModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showAndUpdateNavigationBar(with: "Pick Location", withShadow: true, isHavingBackButton: true, actionController: self, backAction: #selector(self.backBtnAction(_:)))
        self.imageViiew.image = UIImage.fontAwesomeIcon(code: FontAwesome.mapMarkerAlt.rawValue, style: .solid, textColor: ColorConstant.themePrimary.color, size: CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnAction(_:)))
    }
    
    @objc func doneBtnAction(_ sender: UIBarButtonItem) {
        self.pickAddress?(AddressModel(id: "", address: self.addressLabel.text!, coordinate: self.coordinate))
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backBtnAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        self.addressLabel.unlock()
        
        self.coordinate = coordinate
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            self.addressLabel.text = lines.joined(separator: "\n")
            
            let labelHeight = self.addressLabel.intrinsicContentSize.height
            if #available(iOS 11.0, *) {
                self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                    bottom: labelHeight, right: 0)
                
                UIView.animate(withDuration: 0.25) {
                    self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
                    self.view.layoutIfNeeded()
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension PickAddressViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        self.locationManager.stopUpdatingLocation()
    }
}

// MARK: - GMSMapViewDelegate
extension PickAddressViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.reverseGeocodeCoordinate(position.target)
    }
}
