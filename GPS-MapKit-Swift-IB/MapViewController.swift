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
    
    func centerMapOnLoc(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 12000, 12000)
        self.mapView.setRegion(region, animated: false)

    }
    
    func makePinForRestaurant() {
        
        let coord = CLLocationCoordinate2DMake(restLat, restLon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = restTitle
        self.mapView.addAnnotation(annotation)
        
    }
    

// MARK: Mapkit delegate methods
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        if let loc = userLocation.location {
            
            centerMapOnLoc(loc)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
