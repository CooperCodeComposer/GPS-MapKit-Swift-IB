//
//  TableViewController.swift
//  GPS-MapKit-Swift-IB
//
//  Created by Alistair Cooper on 6/1/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController {
    
    let restaurantCatArray = ["Cafe", "Pizza", "Thai"]  // array of restaurant categories
    var restaurantArray: [[String:String]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadRestaurants()
    }
    
    func downloadRestaurants() {
        
        // start network pinwheel
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            if let url = NSURL(string: "https://s3-us-west-2.amazonaws.com/uclaiosclass/restaurants.json") {
                if let timesJsonData = try? NSData(contentsOfURL: url, options: []) {
                    do {
                        self.restaurantArray = try NSJSONSerialization.JSONObjectWithData(timesJsonData, options: .AllowFragments) as? [[String : String]]
                        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                            self.tableView.reloadData()
                            // stop network pinwheel
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        }
                    } catch {
                        self.showError()
                    }
                } else {
                    self.showError()
                }
            } else {
                self.showError()
            }
        }
    }
    
    func showError() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            let ac = UIAlertController(title: "Loading Error", message: "Could not download restaurant data.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurantCatArray.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return restaurantCatArray[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionCatTitle = restaurantCatArray[section]
        
        var filteredArray: [[String:String]]
        
        if let downloadedArray = restaurantArray {
            filteredArray = downloadedArray.filter({
                
                $0["category"] == sectionCatTitle //access the value to filter
            })
            
        } else {
            print("Error: restaurant data could not be downloaded")
            filteredArray = [["": ""]]
        }

        return filteredArray.count

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath)
        
        // gets category title from array using section as index
        let sectionCatTitle = restaurantCatArray[indexPath.section]
        
        // use category name to make array of matching restaurants
        var filteredArray: [[String:String]]
        
        if let downloadedArray = restaurantArray {
            filteredArray = downloadedArray.filter({
                
                $0["category"] == sectionCatTitle //access the value to filter
            })
            
        } else {
            print("Error: restaurant data could not be downloaded")
            filteredArray = [["": ""]]
        }
        
        // make a dictionary of just object at index path
        let restDict: NSDictionary = filteredArray[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = restDict.objectForKey("name") as? String
        cell.detailTextLabel?.text = restDict.objectForKey("price") as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMapSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destinationViewController as! MapViewController
                
                // gets category title from array using section as index
                let sectionCatTitle = restaurantCatArray[indexPath.section]
                
                // use category name to make array of matching restaurants
                var filteredArray: [[String:String]]
                
                if let downloadedArray = restaurantArray {
                    filteredArray = downloadedArray.filter({
                        
                        $0["category"] == sectionCatTitle //access the value to filter
                    })
                    
                } else {
                    print("Error: restaurant data could not be downloaded")
                    filteredArray = [["": ""]]
                }
                
                // make a dictionary of just object at index path
                let restDict: NSDictionary = filteredArray[indexPath.row] as NSDictionary
                
                // assign selected restaurant lat and lon
                controller.restLat = (restDict.objectForKey("yLoc")?.doubleValue)!
                controller.restLon = (restDict.objectForKey("xLoc")?.doubleValue)!
                controller.restTitle = restDict.objectForKey("name") as? String
            }
        }
    }

}
