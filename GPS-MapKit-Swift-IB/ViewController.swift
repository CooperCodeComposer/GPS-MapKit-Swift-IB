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
        
        // setup corelocation
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let current: CLLocation = locations.last!
        
        let lat = current.coordinate.latitude
        let lon = current.coordinate.longitude
        
        latitudeLabel.text = String(format: "Latitude: %.6f", lat)
        longitudeLabel.text = String(format: "Longitude: %.6f", lon)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        headingLabel.text = String(format: "Heading: %.1f", newHeading.magneticHeading)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

