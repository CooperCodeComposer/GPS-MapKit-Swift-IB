//
//  ViewController.swift
//  GPS-MapKit-Swift-IB
//
//  Created by Alistair Cooper on 5/30/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // build the json file
        /*
        let jsonObject = JsonBuilder.makeRestaurantArray()
        let jsonString = JsonBuilder.JSONStringify(jsonObject: jsonObject, prettyPrinted: true)
        print(jsonString)
        */
        
        // setup core location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let current: CLLocation = locations.last else { return }
        
        let lat = current.coordinate.latitude
        let lon = current.coordinate.longitude
        
        latitudeLabel.text = String(format: "Latitude: %.6f", lat)
        longitudeLabel.text = String(format: "Longitude: %.6f", lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        headingLabel.text = String(format: "Heading: %.1f", newHeading.magneticHeading)
    }
    

}

