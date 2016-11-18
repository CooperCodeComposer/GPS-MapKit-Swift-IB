//
//  MapViewController.swift
//  GPS-MapKit-Swift-IB
//
//  Created by Alistair Cooper on 6/1/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    
    var restLon: CLLocationDegrees = 0.0
    var restLat: CLLocationDegrees = 0.0
    var restTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePinForRestaurant()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // sets zoom scale using selected restaurant coordinates
        setZoomScale()
    }
    
    /* uncomment if you'd like app to center on current location
    func centerMapOnLoc(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 12000, 12000)
        self.mapView.setRegion(region, animated: false)

    }
    */
    
    func makePinForRestaurant() {
        
        let coord = CLLocationCoordinate2DMake(restLat, restLon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = restTitle
        self.mapView.addAnnotation(annotation)
        
    }
    
    func setZoomScale() {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let location = CLLocationCoordinate2D(latitude: restLat, longitude: restLon)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    

// MARK: Mapkit delegate methods
    /* uncomment if you'd like app to center on current location
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        if let loc = userLocation.location {
            centerMapOnLoc(loc)
        }
    }
    */

}
