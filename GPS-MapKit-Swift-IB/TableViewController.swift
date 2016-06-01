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
    
    let restaurantCatArray = ["Cafe", "Pizza", "Thai"]
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
            filteredArray = [["empty": "empty"]]
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
            filteredArray = [["empty": "empty"]]
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
                    filteredArray = [["empty": "empty"]]
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
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
