//
//  InProgressTableViewCell.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 8/7/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit
import GoogleMaps

protocol InProgressOrderProtocol {
    func modifyOrder()
    func cloneOrder()
    func cancelOrder()
}

class InProgressTableViewCell: UITableViewCell {
    static var identifier = "InProgressTableViewCell"

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var courierBoyImage: UIImageView!
    @IBOutlet weak var lblCourierBoyName: UILabel!
    
    var delegate: InProgressOrderProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(with order: Order) {
        self.lblAmount.text = order.price
        self.lblAddress.text = order.pickUp.address
        self.lblCourierBoyName.text = order.driverName
        
        self.courierBoyImage.pin_updateWithProgress = true
        self.courierBoyImage.pin_setImage(from: URL(string: order.driverImage))
        
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
        
        bounds = bounds.includingCoordinate(self.placeMarker(address: order.pickUp).position)
        for deliveryAddr in order.delivery {
            bounds = bounds.includingCoordinate(self.placeMarker(address: deliveryAddr).position)
        }
        
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    func placeMarker(address: OrderAddress) -> GMSMarker {
        let lat: Double = NSString(string: address.lat).doubleValue
        let long: Double = NSString(string: address.long).doubleValue
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = address.userName
        marker.snippet = address.address
        marker.map = self.mapView
        return marker
    }
    
    //MARK: - Action Methods
    @IBAction func modifyBtnAction(_ sender: UIButton) {
        self.delegate?.modifyOrder()
    }
    
    @IBAction func cloneBtnAction(_ sender: UIButton) {
        self.delegate?.cloneOrder()
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.delegate?.cancelOrder()
    }
}
